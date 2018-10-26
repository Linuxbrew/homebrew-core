require "os/linux/glibc"

class GccAT6 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-6.4.0/gcc-6.4.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-6.4.0/gcc-6.4.0.tar.xz"
  sha256 "850bf21eafdfe5cd5f6827148184c08c4a0852a37ccf36ce69855334d2c914d4"
  revision OS.mac? ? 2 : 4

  # gcc is designed to be portable.
  bottle do
    cellar :any
    rebuild 2
    sha256 "ddcbc0f556c7a9489a161186ec12f3cb745d8fe996c2530cb199f21c32305c0e" => :mojave
    sha256 "976bbd556683514b2495eccd2bab36d984f26c795aa580dcf361e9bae4d29511" => :high_sierra
    sha256 "341c3917417ac6cfe1712f3005ce89cd1d94db8e0876bfcc36ecd34ed6b21d16" => :sierra
    sha256 "e40695e1d6b66eb170469798844a4757ca9b1ac8e48bab6e37039bd1cbfec52b" => :el_capitan
    sha256 "1481fbb262fe7ef2b313cc148fc71857fbd2847b60f3349247308be45ca5ee20" => :x86_64_linux
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { !OS.mac? || MacOS::CLT.installed? }
  end

  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-jit", "Build the jit compiler"
  option "without-fortran", "Build without the gfortran compiler"

  unless OS.mac?
    depends_on "zlib"
    depends_on "binutils" if build.with? "glibc"
    depends_on "glibc" => (Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version) ? :recommended : :optional
  end
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  fails_with :gcc_4_0

  # Fix for libgccjit.so linkage on Darwin
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64089
  # https://github.com/Homebrew/homebrew-core/issues/1872#issuecomment-225625332
  # https://github.com/Homebrew/homebrew-core/issues/1872#issuecomment-225626490
  if OS.mac?
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9e0ee09389a54cc4c8fe1c24ebca3cd765ed0ba/gcc/6.1.0-jit.patch"
      sha256 "863957f90a934ee8f89707980473769cff47ca0663c3906992da6afb242fb220"
    end
  end

  # Fix parallel build on APFS filesystem
  # Remove for 6.5.0 and later
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81797
  if OS.mac? && MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/df0465c02a/gcc/apfs.patch"
      sha256 "f7772a6ba73f44a6b378e4fe3548e0284f48ae2d02c701df1be93780c1607074"
    end
  end

  # isl 0.20 compatibility
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=86724
  patch :DATA

  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j16" if ENV["CIRCLECI"]

    if build.with? "all-languages"
      # Everything but Ada, which requires a pre-existing GCC Ada compiler
      # (gnat) to bootstrap. GCC 4.6.0 adds go as a language option, but it is
      # currently only compilable on Linux.
      languages = %w[c c++ objc obj-c++ fortran jit]
    else
      # C, C++, ObjC compilers are always built
      languages = %w[c c++ objc obj-c++]

      languages << "fortran" if build.with? "fortran"
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
      arch = MacOS.prefer_64_bit? ? "x86_64" : "i686"
      args += [
        "--build=#{arch}-apple-darwin#{osmajor}",
        "--with-system-zlib",
        "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      ]

      # The pre-Mavericks toolchain requires the older DWARF-2 debugging data
      # format to avoid failure during the stage 3 comparison of object files.
      # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=45248
      args << "--with-dwarf2" if MacOS.version <= :mountain_lion
    else
      args += [
        "--with-bugurl=https://github.com/Linuxbrew/homebrew-core/issues",
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
      else
        # Set the search path for glibc libraries and objects, using the system's glibc
        # Fix the error: ld: cannot find crti.o: No such file or directory
        ENV.prepend_path "LIBRARY_PATH", Pathname.new(Utils.popen_read(ENV.cc, "-print-file-name=crti.o")).parent
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
      "--with-isl=#{Formula["isl"].opt_prefix}",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      # Use 'bootstrap-debug' build configuration to force stripping of object
      # files prior to comparison during bootstrap (broken by Xcode 6.3).
      "--with-build-config=bootstrap-debug",
      "--disable-werror",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
    ]

    args << "--disable-nls" if build.without? "nls"

    # Fix Linux error: gnu/stubs-32.h: No such file or directory.
    if OS.mac? && MacOS.prefer_64_bit?
      args << "--enable-multilib"
    else
      args << "--disable-multilib"
    end

    args << "--enable-host-shared" if build.with?("jit") || build.with?("all-languages")

    # Xcode 10 dropped 32-bit support
    args << "--disable-multilib" if OS.mac? && DevelopmentTools.clang_build_version >= 1000

    # Ensure correct install names when linking against libgcc_s;
    # see discussion in https://github.com/Homebrew/homebrew/pull/34303
    inreplace "libgcc/config/t-slibgcc-darwin", "@shlib_slibdir@", "#{HOMEBREW_PREFIX}/lib/gcc/#{version_suffix}" if OS.mac?

    mkdir "build" do
      if OS.mac?
        if !MacOS::CLT.installed?
          # For Xcode-only systems, we need to tell the sysroot path
          args << "--with-native-system-header-dir=/usr/include"
          args << "--with-sysroot=#{MacOS.sdk_path}"
        elsif MacOS.version >= :mojave
          # System headers are no longer located in /usr/include
          args << "--with-native-system-header-dir=/usr/include"
          args << "--with-sysroot=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
        end
      end

      system "../configure", *args
      system "make", "bootstrap"
      system "make", OS.mac? ? "install" : "install-strip"
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
    unless OS.mac?
      gcc = bin/"gcc-6"
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

      if glibc_installed
        # https://github.com/Linuxbrew/brew/issues/724
        system_header_dirs << glibc.opt_include
      else
        # Locate the native system header dirs if user uses system glibc
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
      #   * `-L#{libdir}` instructs gcc to find the corresponding gcc
      #     libraries. It is essential if there are multiple brewed gcc
      #     with different versions installed.
      #     Noted that it should only be passed for the `gcc@*` formulae.
      #   * `-L#{HOMEBREW_PREFIX}/lib` instructs gcc to find the rest
      #     brew libraries.
      libdir = HOMEBREW_PREFIX/"lib/gcc/6"
      specs.write specs_string + <<~EOS
        *cpp_unique_options:
        + -isysroot #{HOMEBREW_PREFIX}/nonexistent #{system_header_dirs.map { |p| "-idirafter #{p}" }.join(" ")}

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
    system "#{bin}/gcc-6", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system "#{bin}/g++-6", "-o", "hello-cc", "hello-cc.cc"
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
      system "#{bin}/gfortran-6", "-o", "test", "in.f90"
      assert_equal "done", `./test`.strip
    end
  end
end

__END__
diff --git a/gcc/graphite.h b/gcc/graphite.h
index 578fa1a..e4fad06 100644
--- a/gcc/graphite.h
+++ b/gcc/graphite.h
@@ -36,6 +36,8 @@ along with GCC; see the file COPYING3.  If not see
 #include <isl/ilp.h>
 #include <isl/schedule.h>
 #include <isl/ast_build.h>
+#include <isl/id.h>
+#include <isl/space.h>

 #ifdef HAVE_ISL_OPTIONS_SET_SCHEDULE_SERIALIZE_SCCS
 /* isl 0.15 or later.  */
