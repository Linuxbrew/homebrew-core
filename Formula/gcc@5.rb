class GccAT5 < Formula
  def arch
    if Hardware::CPU.type == :intel
      if MacOS.prefer_64_bit?
        "x86_64"
      else
        "i686"
      end
    elsif Hardware::CPU.type == :ppc
      if MacOS.prefer_64_bit?
        "powerpc64"
      else
        "powerpc"
      end
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  desc "The GNU Compiler Collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-5.5.0/gcc-5.5.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-5.5.0/gcc-5.5.0.tar.xz"
  sha256 "530cea139d82fe542b358961130c69cfde8b3d14556370b65823d2f91f0ced87"
  revision OS.mac? ? 2 : 3

  # gcc is designed to be portable.
  bottle do
    cellar :any
    sha256 "3cef0d77229769d75a85b545be64ea74fdca7fe99b78a08025d9523dae2db4c1" => :high_sierra
    sha256 "831b722a88b94d2663883ede5b301173055ccd68cb2cd8f6231aae79fb7a5910" => :sierra
    sha256 "b900bb57ad020106cfc83d07c6579611b9c7083ce004ee03ce1a2d099e4e2378" => :el_capitan
  end

  # GCC's Go compiler is not currently supported on Mac OS X.
  # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46986
  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-profiled-build", "Make use of profile guided optimization when bootstrapping GCC"
  option "with-jit", "Build the jit compiler"
  option "without-fortran", "Build without the gfortran compiler"

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  unless OS.mac?
    depends_on "isl@0.18"
    depends_on "zlib"
    depends_on "binutils" if build.with? "glibc"
    depends_on "glibc" => (Formula["glibc"].installed? || !GlibcRequirement.new.satisfied?) ? :recommended : :optional
  end

  resource "isl" do
    url "https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.14.tar.bz2"
    mirror "https://mirrorservice.org/sites/distfiles.macports.org/isl/isl-0.14.tar.bz2"
    sha256 "7e3c02ff52f8540f6a85534f54158968417fd676001651c8289c705bd0228f36"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  def pour_bottle?
    MacOS::CLT.installed?
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # Fix for libgccjit.so linkage on Darwin.
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64089
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/64fd2d52/gcc%405/5.4.0.patch"
    sha256 "1e126048d9a6b29b0da04595ffba09c184d338fe963cf9db8d81b47222716bc4"
  end if OS.mac?

  # Fix build with Xcode 9
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82091
  if OS.mac? && DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/078797f1b9/gcc%405/xcode9.patch"
      sha256 "e1546823630c516679371856338abcbab381efaf9bd99511ceedcce3cf7c0199"
    end
  end

  # Fix Apple headers, otherwise they trigger a build failure in libsanitizer
  # GCC bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83531
  # Apple radar 36176941
  if OS.mac? && MacOS.version == :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/413cfac6/gcc%405/10.13_headers.patch"
      sha256 "94aaec20c8c7bfd3c41ef8fb7725bd524b1c0392d11a411742303a3465d18d09"
    end
  end

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Build ISL 0.14 from source during bootstrap
    resource("isl").stage buildpath/"isl" if OS.mac?

    if build.with? "all-languages"
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ fortran java objc obj-c++ jit]
    else
      # C, C++, ObjC compilers are always built
      languages = %w[c c++ objc obj-c++]

      languages << "fortran" if build.with? "fortran"
      languages << "java" if build.with? "java"
      languages << "jit" if build.with? "jit"
    end

    version_suffix = version.to_s.slice(/\d/)

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    args = []

    if OS.mac?
      osmajor = `uname -r`.chomp
      args += [
        "--build=#{arch}-apple-darwin#{osmajor}",
        "--with-system-zlib",
        "--enable-libstdcxx-time=yes",
        "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      ]
    else
      args += [
        "--with-isl=#{Formula["isl@0.18"].opt_prefix}",
        "--with-bugurl=https://github.com/Linuxbrew/homebrew-core/issues",
        # Fix cc1: error while loading shared libraries: libisl.so.15
        "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}",
      ]

      # Change the default directory name for 64-bit libraries to `lib`
      # http://www.linuxfromscratch.org/lfs/view/development/chapter06/gcc.html
      inreplace "gcc/config/i386/t-linux64", "m64=../lib64", "m64="

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
      end
    end

    args += [
      "--prefix=#{prefix}",
      "--libdir=#{lib}/gcc/#{version_suffix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      "--enable-plugin",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
    ]

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_share}/java/ecj.jar"
    end

    # Fix Linux error: gnu/stubs-32.h: No such file or directory.
    if OS.mac? && MacOS.prefer_64_bit?
      args << "--enable-multilib"
    else
      args << "--disable-multilib"
    end

    args << "--enable-host-shared" if build.with?("jit") || build.with?("all-languages")

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}" if OS.mac?

    mkdir "build" do
      if OS.mac? && !MacOS::CLT.installed?
        # For Xcode-only systems, we need to tell the sysroot path.
        # "native-system-headers" will be appended
        args << "--with-native-system-header-dir=/usr/include"
        args << "--with-sysroot=#{MacOS.sdk_path}"
      end

      system "../configure", *args

      if build.with? "profiled-build"
        # Takes longer to build, may bug out. Provided for those who want to
        # optimise all the way to 11.
        system "make", "profiledbootstrap"
      else
        system "make", "bootstrap"
      end

      # At this point `make check` could be invoked to run the testsuite. The
      # deja-gnu and autogen formulae must be installed in order to do this.
      system "make", "install"
    end

    # Handle conflicts between GCC formulae.
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
    unless OS.mac?
      gcc = bin/"gcc-5"
      libgcc = Pathname.new(Utils.popen_read(gcc, "-print-libgcc-file-name")).parent
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?

      glibc = Formula["glibc"]
      glibc_installed = glibc.any_version_installed?

      # Symlink crt1.o and friends where gcc can find it.
      ln_sf Dir[glibc.opt_lib/"*crt?.o"], libgcc if glibc_installed

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
      #   * `-isysroot /nonexistent` prevents gcc searching built-in
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
      libdir = HOMEBREW_PREFIX/"lib/gcc/5"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot /nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

        *link_libgcc:
        #{glibc_installed ? "-nostdlib -L#{libgcc}" : "+"} -L#{libdir} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{libdir} -rpath #{HOMEBREW_PREFIX}/lib

      EOS
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
    system bin/"gcc-5", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
