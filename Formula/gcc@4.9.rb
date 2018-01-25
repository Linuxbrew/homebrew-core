# gcc@4.9: Build a bottle for Linuxbrew
class GccAT49 < Formula
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
  url "https://ftp.gnu.org/gnu/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-4.9.4/gcc-4.9.4.tar.bz2"
  sha256 "6c11d292cd01b294f9f84c9a59c230d80e9e4a47e5c6355f046bb36d4f358092"

  bottle do
    rebuild 1
    sha256 "4937871b632dffecbf47ea0a0fc71ad2b01fd798f1504b5d9e43d47f88b73ab8" => :high_sierra
    sha256 "fe92625f4620e178704734894da2b9d48b977604e0a8860254fbe95fe6d6fe29" => :sierra
    sha256 "d61fd4552e4f2c130630b39a53d6e16f8dc9477ccfbcb21e378c42df5f47ae32" => :el_capitan
  end

  option "without-fortran", "Build without the gfortran compiler"
  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-profiled-build", "Make use of profile guided optimization when bootstrapping GCC"

  deprecated_option "enable-java" => "with-java"
  deprecated_option "enable-all-languages" => "with-all-languages"
  deprecated_option "enable-nls" => "with-nls"
  deprecated_option "enable-profiled-build" => "with-profiled-build"

  unless OS.mac?
    depends_on "zlib"
    depends_on "binutils" if build.with? "glibc"
    depends_on "glibc" => (Formula["glibc"].installed? || !GlibcRequirement.new.satisfied?) ? :recommended : :optional
  end
  depends_on "gmp@4"
  depends_on "libmpc@0.8"
  depends_on "mpfr@2"
  depends_on "cloog"
  depends_on "isl@0.12"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    default_prefix = BottleSpecification::DEFAULT_PREFIX
    reason "The bottle needs the Xcode CLT to be installed and to be installed into #{default_prefix}."
    satisfy { !OS.mac? || (MacOS::CLT.installed? && HOMEBREW_PREFIX.to_s == default_prefix) }
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # Fix build with Xcode 9
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82091
  if DevelopmentTools.clang_build_version >= 900
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/c2dae73416/gcc%404.9/xcode9.patch"
      sha256 "92c13867afe18ccb813526c3b3c19d95a2dd00973f9939cf56ab7698bdd38108"
    end
  end

  # Fix issues with macOS 10.13 headers and parallel build on APFS
  if MacOS.version == :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/b7c7883d/gcc%404.9/high_sierra_2.patch"
      sha256 "c7bcad4657292f6939b7322eb5e821c4a110c4f326fd5844890f0e9a85da8cae"
    end
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j4 -l2.5" if ENV["CIRCLECI"]

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    if build.with? "all-languages"
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 add go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ fortran java objc obj-c++]
    else
      # C, C++, ObjC compilers are always built
      languages = %w[c c++ objc obj-c++]

      languages << "fortran" if build.with? "fortran"
      languages << "java" if build.with? "java"
    end

    version_suffix = version.to_s.slice(/\d\.\d/)

    args = []
    if OS.mac?
      args << "--build=#{arch}-apple-darwin#{osmajor}"
      args << "--libdir=#{lib}/gcc/#{version_suffix}"
    end
    if build.with? "glibc"
      # Fix for GCC 4.4 and older that do not support -static-libstdc++
      # gengenrtl: error while loading shared libraries: libstdc++.so.6
      mkdir_p lib
      ln_s ["/usr/lib64/libstdc++.so.6", "/lib64/libgcc_s.so.1"], lib
      binutils = Formula["binutils"].prefix/"x86_64-unknown-linux-gnu/bin"
      args += [
        "--with-native-system-header-dir=#{HOMEBREW_PREFIX}/include",
        "--with-local-prefix=#{HOMEBREW_PREFIX}/local",
        "--with-build-time-tools=#{binutils}",
      ]
      # Set the search path for glibc libraries and objects.
      ENV["LIBRARY_PATH"] = Formula["glibc"].lib
    end
    args = [
      "--prefix=#{prefix}",
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp@4"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr@2"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc@0.8"].opt_prefix}",
      "--with-cloog=#{Formula["cloog"].opt_prefix}",
      "--with-isl=#{Formula["isl@0.12"].opt_prefix}",
      ("--with-system-zlib" if OS.mac?),
      "--enable-libstdcxx-time=yes",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      "--enable-plugin",
      # Use 'bootstrap-debug' build configuration to force stripping of object
      # files prior to comparison during bootstrap (broken by Xcode 6.3).
      "--with-build-config=bootstrap-debug",
      # A no-op unless --HEAD is built because in head warnings will
      # raise errors. But still a good idea to include.
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      # Even when suffixes are appended, the info pages conflict when
      # install-info is run.
      "MAKEINFO=missing",
    ]

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_prefix}/share/java/ecj.jar"
    end

    if MacOS.prefer_64_bit?
      args << "--enable-multilib"
    else
      args << "--disable-multilib"
    end

    ENV["CPPFLAGS"] = "-I#{Formula["zlib"].include}" unless OS.mac?

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}"

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

      unless OS.mac?
        # Create cpp, gcc and g++ symlinks
        bin.install_symlink "cpp-#{version_suffix}" => "cpp"
        bin.install_symlink "gcc-#{version_suffix}" => "gcc"
        bin.install_symlink "g++-#{version_suffix}" => "g++"
      end
    end

    # Handle conflicts between GCC formulae.
    # Rename man7.
    Dir.glob(man7/"*.7") { |file| add_suffix file, version_suffix }
    # Even when we disable building info pages some are still installed.
    info.rmtree

    unless OS.mac?
      # Strip the executables to reduce their size from 600 MB to 100 MB.
      libexecgcc = libexec/"gcc/x86_64-unknown-linux-gnu"/version
      system "strip", *(Dir[libexecgcc/"*"] - Dir[libexecgcc/"*.la"]).select { |f| File.file? f }
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

      # Symlink crt1.o and friends where gcc can find it.
      gcc = "#{bin}/gcc-#{version_suffix}"
      libgccdir = Pathname.new(`#{gcc} -print-libgcc-file-name`).dirname
      glibc = Formula["glibc"]
      ln_sf Dir[glibc.opt_lib/"*crt?.o"], libgccdir if glibc.any_version_installed?

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      specs = libgccdir/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      # Save a backup of the default specs file
      specs_string = `#{gcc} -dumpspecs`
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?
      specs_orig.write specs_string

      # Set the library search path
      libgcc = lib/"gcc/x86_64-unknown-linux-gnu"/version
      specs.write specs_string + <<-EOS.undent
        *cpp_unique_options:
        + -isystem #{HOMEBREW_PREFIX}/include

        *link_libgcc:
        #{glibc.any_version_installed? ? "-nostdlib -L#{libgcc}" : "+"} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{HOMEBREW_PREFIX}/lib

      EOS

      # Symlink ligcc_s.so.1 where glibc can find it.
      # Fix the error: libgcc_s.so.1 must be installed for pthread_cancel to work
      ln_sf opt_lib/"libgcc_s.so.1", glibc.opt_lib if glibc.any_version_installed?
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
    system bin/"gcc-4.9", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`
  end
end
