require "os/linux/glibc"

class Gcc < Formula
  def arch
    if MacOS.prefer_64_bit?
      "x86_64"
    else
      "i686"
    end
  end

  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  revision OS.mac? ? 2 : 4
  head "https://gcc.gnu.org/git/gcc.git" if OS.mac?

  if OS.mac?
    url "https://ftp.gnu.org/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-8.3.0/gcc-8.3.0.tar.xz"
    sha256 "64baadfe6cc0f4947a84cb12d7f0dfaf45bb58b7e92461639596c21e02d97d2c"
  else
    url "https://ftp.gnu.org/gnu/gcc/gcc-5.5.0/gcc-5.5.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-5.5.0/gcc-5.5.0.tar.xz"
    sha256 "530cea139d82fe542b358961130c69cfde8b3d14556370b65823d2f91f0ced87"
  end

  # gcc is designed to be portable.
  bottle do
    cellar :any
    rebuild 2
    sha256 "78b5b3a98b82f7c89263c5d972a11f01d87a78f70842d889ae9698be57e68f94" => :mojave
    sha256 "092330ee694a9026ac90f2e69d9b92f4c2f9a3b767ba9bc52744a8d1fdfa0b22" => :high_sierra
    sha256 "11c79eb32b576804f63ec0c5931b50bc77b61302c7a9d3ef3a5f2d620772ef36" => :sierra
    sha256 "406111bf6c70681f2acbf39bb2462da0a15e1522d01bd909abed43556dff50ca" => :x86_64_linux
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed and to be installed into #{Homebrew::DEFAULT_PREFIX}."
    satisfy { !OS.mac? || (MacOS::CLT.installed? && HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX) }
  end

  unless OS.mac?
    depends_on "zlib"
    depends_on "binutils" if build.with? "glibc"
    depends_on "glibc" => (Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version) ? :recommended : :optional
  end
  depends_on "gmp"
  depends_on "isl" if OS.mac?
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "isl@0.18" unless OS.mac?

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # Patch for Xcode bug, taken from https://gcc.gnu.org/bugzilla/show_bug.cgi?id=89864#c43
  # This should be removed in the next release of GCC if fixed by apple; this is an xcode bug,
  # but this patch is a work around committed to GCC trunk
  if OS.mac? && MacOS::Xcode.version >= "10.2"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/gcc/8.3.0-xcode-bug-_Atomic-fix.patch"
      sha256 "33ee92bf678586357ee8ab9d2faddf807e671ad37b97afdd102d5d153d03ca84"
    end
  end

  def version_suffix
    if build.head?
      "HEAD"
    else
      version.to_s.slice(/\d/)
    end
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8 -l2.5" if ENV["CIRCLECI"]

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    if build.with? "all-languages"
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 adds go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ objc obj-c++ fortran java jit]
    else
      # C, C++, ObjC compilers are always built
      languages = %w[c c++ objc obj-c++]
    end

    args = []

    if OS.mac?
      osmajor = `uname -r`.split(".").first
      args += [
        "--build=#{arch}-apple-darwin#{osmajor}",
        "--libdir=#{lib}/gcc/#{version_suffix}",
        "--with-isl=#{Formula["isl"].opt_prefix}",
        "--with-system-zlib",
        "--with-bugurl=https://github.com/Homebrew/homebrew/issues",
      ]
    else
      args += [
        "--with-isl=#{Formula["isl@0.18"].opt_prefix}",
        "--with-bugurl=https://github.com/Linuxbrew/homebrew-core/issues",
      ]

      # Change the default directory name for 64-bit libraries to `lib`
      # http://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="

      # Fix for system gccs that do not support -static-libstdc++
      # gengenrtl: error while loading shared libraries: libstdc++.so.6
      mkdir_p lib
      ln_s Utils.popen_read(ENV.cc, "-print-file-name=libstdc++.so.6").strip, lib
      ln_s Utils.popen_read(ENV.cc, "-print-file-name=libgcc_s.so.1").strip, lib

      if build.with? "glibc"
        args += [
          "--with-native-system-header-dir=#{HOMEBREW_PREFIX}/include",
          # Pass the specs to ./configure so that gcc can pickup brewed glibc.
          # This fixes the building failure if the building system uses brewed gcc
          # and brewed glibc. Document on specs can be found at
          # https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html
          # Howerver, there is very limited document on `--with-specs` option,
          # which has certain difference compared with regular spec file.
          # But some relevant information can be found at https://stackoverflow.com/a/47911839
          "--with-specs=%{!static:%x{--dynamic-linker=#{HOMEBREW_PREFIX}/lib/ld.so} %x{-rpath=#{HOMEBREW_PREFIX}/lib}}",
        ]
        # Set the search path for glibc libraries and objects.
        # Fix the error: ld: cannot find crti.o: No such file or directory
        ENV["LIBRARY_PATH"] = Formula["glibc"].opt_lib
      else
        # Set the search path for glibc libraries and objects, using the system's glibc
        # Fix the error: ld: cannot find crti.o: No such file or directory
        ENV.prepend_path "LIBRARY_PATH", Pathname.new(Utils.popen_read(ENV.cc, "-print-file-name=crti.o")).parent
      end
    end

    # Fix cc1: error while loading shared libraries: libisl.so.15
    args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}" unless OS.mac?

    pkgversion = "Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip
    args += [
      "--prefix=#{prefix}",
      "--disable-nls",
      "--enable-checking=release",
      "--enable-languages=#{languages.join(",")}",
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-pkgversion=#{pkgversion}",
    ]

    # Xcode 10 dropped 32-bit support
    args << "--disable-multilib" if DevelopmentTools.clang_build_version >= 1000

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/legacy-homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}" if OS.mac?

    mkdir "build" do
      if OS.mac? && !MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      elsif MacOS.version >= :mojave
        # System headers are no longer located in /usr/include
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      end

      # Fix Linux error: gnu/stubs-32.h: No such file or directory
      if OS.mac? && MacOS.prefer_64_bit?
        args << "--enable-multilib"
      else
        args << "--disable-multilib"
      end

      system "../configure", *args

      # Use -headerpad_max_install_names in the build,
      # otherwise updated load commands won't fit in the Mach-O header.
      # This is needed because `gcc` avoids the superenv shim.
      system "make", "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      system "make", OS.mac? ? "install" : "install-strip"

      if build.with?("fortran") || build.with?("all-languages")
        bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
      end
      unless OS.mac?
        # Create cpp, gcc and g++ symlinks
        bin.install_symlink "cpp-#{version_suffix}" => "cpp"
        bin.install_symlink "gcc-#{version_suffix}" => "gcc"
        bin.install_symlink "g++-#{version_suffix}" => "g++"
      end
    end

    # Handle conflicts between GCC formulae and avoid interfering
    # with system compilers.
    # Since GCC 4.8 libffi stuff are no longer shipped.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when suffixes are appended, the info pages conflict when
    # install-info is run. TODO fix this.
    info.rmtree

    # Rename java properties
    if build.with?("java") || build.with?("all-languages")
      config_files = [
        "#{lib}/gcc/#{version_suffix}/logging.properties",
        "#{lib}/gcc/#{version_suffix}/security/classpath.security",
        "#{lib}/gcc/#{version_suffix}/i386/logging.properties",
        "#{lib}/gcc/#{version_suffix}/i386/security/classpath.security",
      ]
      config_files.each do |file|
        add_suffix file, version_suffix if File.exist? file
      end
    end
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    unless OS.mac?
      # Create cc and c++ symlinks, unless they already exist
      homebrew_bin = Pathname.new "#{HOMEBREW_PREFIX}/bin"
      homebrew_bin.install_symlink "gcc" => "cc" unless (homebrew_bin/"cc").exist?
      homebrew_bin.install_symlink "g++" => "c++" unless (homebrew_bin/"c++").exist?

      gcc = "#{bin}/gcc-#{version_suffix}"
      libgcc = Pathname.new(Utils.popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink crt1.o and friends where gcc can find it.
      if glibc_installed
        crtdir = glibc.opt_lib
      else
        crtdir = Pathname.new(Utils.popen_read("/usr/bin/cc", "-print-file-name=crti.o")).parent
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

      # Locate the native system header dirs if user uses system glibc
      unless glibc_installed
        target = Utils.popen_read(gcc, "-print-multiarch").chomp
        raise "command failed: #{gcc} -print-multiarch" if $CHILD_STATUS.exitstatus.nonzero?

        system_header_dirs += ["/usr/include/#{target}", "/usr/include"]
      end

      # Save a backup of the default specs file
      specs_string = Utils.popen_read(gcc, "-dumpspecs")
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
      #   * `-L#{HOMEBREW_PREFIX}/lib` instructs gcc to find the rest
      #     brew libraries.
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{HOMEBREW_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc}" : "+"} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{HOMEBREW_PREFIX}/lib

      EOS

      # Symlink ligcc_s.so.1 where glibc can find it.
      # Fix the error: libgcc_s.so.1 must be installed for pthread_cancel to work
      ln_sf opt_lib/"libgcc_s.so.1", glibc.opt_lib if glibc_installed
    end
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

    if build.with?("fortran") || build.with?("all-languages")
      fixture = <<~EOS
        integer,parameter::m=10000
        real::a(m), b(m)
        real::fact=0.5

        do concurrent (i=1:m)
          a(i) = a(i) + fact*b(i)
        end do
        print *, "done"
        end
      EOS
      (testpath/"in.f90").write(fixture)
      system "#{bin}/gfortran", "-c", "in.f90"
      system "#{bin}/gfortran", "-o", "test", "in.o"
      assert_equal "done", `./test`.strip
    end
  end
end
