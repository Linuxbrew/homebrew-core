require "os/linux/glibc"

class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  head "https://gcc.gnu.org/git/gcc.git"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz"
  sha256 "b6898a23844b656f1b68691c5c012036c2e694ac4b53a8918d4712ad876e7ea2"
  head "https://gcc.gnu.org/git/gcc.git"

  # gcc is designed to be portable.
  bottle do
    cellar :any
    sha256 "57e53d66ad43fe05b5a2f93d6a7cfd472713ac03e9d9c9d0d0187cdc7a273153" => :catalina
    sha256 "de8319322428721741a0dc41dfdf2eece80e0215a7a4a861e0e206a9bfbca583" => :mojave
    sha256 "e50b9cfee063619515a8f164485b3f730077f21b49b7bb30cc5a600ddf577a83" => :high_sierra
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { !OS.mac? || MacOS::CLT.installed? }
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  uses_from_macos "zlib"

  depends_on "binutils" unless OS.mac?

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d+/)
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    osmajor = `uname -r`.split(".").first
    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip

    args = %W[
      --prefix=#{prefix}
      --libdir=#{lib}/gcc/#{version_suffix}
      --disable-nls
      --enable-checking=release
      --enable-languages=#{languages.join(",")}
      --program-suffix=-#{version_suffix}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
      --with-system-zlib
      --with-pkgversion=#{pkgversion}
      --with-bugurl=https://github.com/Homebrew/homebrew-core/issues
    ]

    if OS.mac?
      args << "--build=x86_64-apple-darwin#{osmajor}"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

    if OS.mac?
      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
      end

      # Avoid reference to sed shim
      args << "SED=/usr/bin/sed"

    else
      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # http://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="

      # Set the search path for glibc libraries and objects, using the system's glibc
      # Fix the error: ld: cannot find crti.o: No such file or directory
      ENV.prepend_path "LIBRARY_PATH", Pathname.new(Utils.popen_read(ENV.cc, "-print-file-name=crti.o")).parent
    end

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"

    mkdir "build" do
      system "../configure", *args

      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      system "make", *("BOOT_LDFLAGS=-Wl,-headerpad_max_install_names" if OS.mac?)
      system "make", OS.mac? ? "install" : "install-strip"

      bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    return if OS.mac?

    gcc = bin/"gcc-#{version_suffix}"
    libgcc = Pathname.new(Utils.popen_read(gcc, "-print-libgcc-file-name")).parent
    raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

    glibc = Formula["glibc"]
    glibc_installed = glibc.any_version_installed?

    # Symlink crt1.o and friends where gcc can find it.
    crtdir = if glibc_installed
      glibc.opt_lib
    else
      Pathname.new(Utils.safe_popen_read("/usr/bin/cc", "-print-file-name=crti.o")).parent
    end
    ln_sf Dir[crtdir/"*crt?.o"], libgcc

    # Create the GCC specs file
    # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

    # Locate the specs file
    specs = libgcc/"specs"
    ohai "Creating the GCC specs file: #{specs}"
    specs_orig = Pathname.new("#{specs}.orig")
    rm_f [specs_orig, specs]

    system_header_dirs = ["#{HOMEBREW_PREFIX}/include"]

    # Save a backup of the default specs file
    specs_string = Utils.safe_popen_read(gcc, "-dumpspecs")
    raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?

    specs_orig.write specs_string

    # Set the library search path
    # For include path:
    #   * `-isysroot #{HOMEBREW_PREFIX}/nonexistent` prevents gcc searching built-in
    #     system header files.
    #   * `-idirafter <dir>` instructs gcc to search system header
    #     files after gcc internal header files.
    # For libraries:
    #   * `-nostdlib -L#{libgcc}` instructs gcc to use brewed glibc
    #     if applied.
    #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
    #     libraries. It is essential if there are multiple brewed gcc
    #     with different versions installed.
    #     Noted that it should only be passed for the `gcc@*` formulae.
    #   * `-L#{HOMEBREW_PREFIX}/lib` instructs gcc to find the rest
    #     brew libraries.
    libdir = HOMEBREW_PREFIX/"lib/gcc/#{version_suffix}"
    specs.write specs_string + <<~EOS
      *cpp_unique_options:
      + -isysroot #{HOMEBREW_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

      *link_libgcc:
      #{glibc_installed ? "-nostdlib -L#{libgcc}" : "+"} -L#{libdir} -L#{HOMEBREW_PREFIX}/lib

      *link:
      + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{libdir} -rpath #{HOMEBREW_PREFIX}/lib

    EOS
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc-#{version_suffix}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system "#{bin}/g++-#{version_suffix}", "-o", "hello-cc", "hello-cc.cc"
    assert_equal "Hello, world!\n", `./hello-cc`

    (testpath/"test.f90").write <<~EOS
      integer,parameter::m=10000
      real::a(m), b(m)
      real::fact=0.5

      do concurrent (i=1:m)
        a(i) = a(i) + fact*b(i)
      end do
      write(*,"(A)") "Done"
      end
    EOS
    system "#{bin}/gfortran", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`
  end
end
