require "os/linux/glibc"

class Gcc < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  revision 4
  head "https://gcc.gnu.org/git/gcc.git"

  if Hardware::CPU.arm?
    # Branch from the Darwin maintainer of GCC with Apple Silicon support,
    # located at https://github.com/iains/gcc-darwin-arm64 and
    # backported with his help to gcc-10 branch. Too big for a patch.
    url "https://github.com/fxcoudert/gcc/archive/gcc-10-arm-20210220.tar.gz"
    sha256 "53beed690e4e0355d972ad58917a11e01af1cfe67b2e7602ca1ef89c98417a67"
    version "10.2.0"
  else
    url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
    sha256 "b8dd4368bb9c7f0b98188317ee0254dd8cc99d1e3a18d0ff146c855fe16c1d8c"
  end

  livecheck do
    # Should be
    # url :stable
    # but that does not work with the ARM-specific branch above
    url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0"
    regex(%r{href=.*?gcc[._-]v?(\d+(?:\.\d+)+)(?:/?["' >]|\.t)}i)
  end

  bottle do
    sha256 arm64_big_sur: "82f9ed75ca22c2120054b0011430a007eb28d3daa218e523d4c09210c5c32dea"
    sha256 big_sur:       "8b5bbf48a1436297fe001eff470552db520a85c5bace19896572df4ad1a59e88"
    sha256 catalina:      "ad8caedc23b71e5c14eaf4bf5bc747e5ef73620b99b460ef0e17c6e80e17b971"
    sha256 mojave:        "62483f796012e79c433fee8690e817266b704d171d03cb5d6ce75ca558d959a0"
    sha256 x86_64_linux:  "e62efea399fd03d854ff871210b941e5c3277d821e9148badceeda883f53f016"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    on_macos do
      reason "The bottle needs the Xcode CLT to be installed."
      satisfy { MacOS::CLT.installed? }
    end
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  uses_from_macos "zlib"

  on_linux do
    depends_on "binutils"
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  if Hardware::CPU.intel?
    # Patch for Big Sur, remove with GCC 10.3
    # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98805
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/6a83f36d/gcc/bigsur_2.patch"
      sha256 "347a358b60518e1e0fe3c8e712f52bdac1241e44e6c7738549d969c24095f65b"
    end
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.major.to_s
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

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"

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
      --with-pkgversion=#{pkgversion}
      --with-bugurl=#{tap.issues_url}
    ]

    on_macos do
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
      args << "--with-system-zlib"

      # Xcode 10 dropped 32-bit support
      args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

      # System headers may not be in /usr/include
      sdk = MacOS.sdk_path_if_needed
      if sdk
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{sdk}"
      end

      # Avoid reference to sed shim
      args << "SED=/usr/bin/sed"

      # Ensure correct install names when linking against libgcc_s;
      # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
      inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"
    end

    unless OS.mac?
      # Fix cc1: error while loading shared libraries: libisl.so.15
      args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}"

      # Fix Linux error: gnu/stubs-32.h: No such file or directory.
      args << "--disable-multilib"

      # Change the default directory name for 64-bit libraries to `lib`
      # http://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="
    end

    mkdir "build" do
      system "../configure", *args

      make_args = []
      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      make_args << "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names" if OS.mac?
      system "make", *make_args
      system "make", OS.mac? ? "install" : "install-strip"

      bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"

      unless OS.mac?
        lib.install_symlink lib/"gcc/#{version_suffix}/libgfortran.so"
        lib.install_symlink lib/"gcc/#{version_suffix}/libgfortran.a"
        lib.install_symlink lib/"gcc/#{version_suffix}/libgfortran.so.5"
      end
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
    libgcc = Pathname.new(Utils.safe_popen_read(gcc, "-print-libgcc-file-name")).parent
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

    if glibc_installed
      # https://github.com/Linuxbrew/brew/issues/724
      system_header_dirs << glibc.opt_include
    else
      # Locate the native system header dirs if user uses system glibc
      target = Utils.safe_popen_read(gcc, "-print-multiarch").chomp
      raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

      system_header_dirs += ["/usr/include/#{target}", "/usr/include"]
    end

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
      struct exception { };
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        try { throw exception{}; }
          catch (exception) { }
          catch (...) { }
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
