require "os/linux/glibc"

class GccAT7 < Formula
  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"
  url "https://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-7.3.0/gcc-7.3.0.tar.xz"
  sha256 "832ca6ae04636adbb430e865a1451adf6979ab44ca1c8374f61fba65645ce15c"

  # gcc is designed to be portable.
  bottle do
    cellar :any
    rebuild 1
    sha256 "5f798446d0193232ceeb27fa34965ef988ed42796b6aab63e6983304a771afc0" => :high_sierra
    sha256 "47b785a673df97f76b974aed4de9f80426ab69db455f56387f0746d744a375d6" => :sierra
    sha256 "4fed764370e0b2b283d498ac06de3f3d028edad121bc1a3659f4c10c8665ac73" => :el_capitan
  end

  option "with-jit", "Build just-in-time compiler"
  option "with-nls", "Build with native language support (localization)"

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  unless OS.mac?
    depends_on "zlib"
    depends_on "binutils" if build.with? "glibc"
    depends_on "glibc" => (Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version) ? :recommended : :optional
  end

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  # Fix for libgccjit.so linkage on Darwin
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64089
  # https://github.com/Homebrew/homebrew-core/issues/1872#issuecomment-225625332
  # https://github.com/Homebrew/homebrew-core/issues/1872#issuecomment-225626490
  # Now fixed on GCC trunk for GCC 8, may backported to other branches
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e9e0ee09389a54cc4c8fe1c24ebca3cd765ed0ba/gcc/6.1.0-jit.patch"
    sha256 "863957f90a934ee8f89707980473769cff47ca0663c3906992da6afb242fb220"
  end if OS.mac?

  # Fix parallel build on APFS filesystem
  # Remove for 7.4.0 and later
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
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8 -l2.5" if ENV["CIRCLECI"]

    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    version_suffix = version.to_s.slice(/\d/)

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"

    # We avoiding building:
    #  - Ada, which requires a pre-existing GCC Ada compiler to bootstrap
    #  - Go, currently not supported on macOS
    #  - BRIG
    languages = %w[c c++ objc obj-c++ fortran]

    # JIT compiler is off by default, enabling it has performance cost
    languages << "jit" if build.with? "jit"

    args = []

    if OS.mac?
      osmajor = `uname -r`.chomp
      args += [
        "--build=x86_64-apple-darwin#{osmajor}",
        "--with-system-zlib",
        "--with-bugurl=https://github.com/Homebrew/homebrew-core/issues",
      ]
    else
      args += [
        "--with-bugurl=https://github.com/Linuxbrew/homebrew-core/issues",
        # Fix Linux error: gnu/stubs-32.h: No such file or directory.
        "--disable-multilib",
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
      "--enable-checking=release",
      "--with-pkgversion=Homebrew GCC #{pkg_version} #{build.used_options*" "}".strip,
    ]

    args << "--disable-nls" if build.without? "nls"
    args << "--enable-host-shared" if build.with?("jit")

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

      make_args = []
      # Use -headerpad_max_install_names in the build,
      # otherwise lto1 load commands cannot be edited on El Capitan
      if MacOS.version == :el_capitan
        make_args << "BOOT_LDFLAGS=-Wl,-headerpad_max_install_names"
      end

      system "make", *make_args
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
      gcc = bin/"gcc-7"
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
      libdir = HOMEBREW_PREFIX/"lib/gcc/7"
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
    system "#{bin}/gcc-7", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<~EOS
      #include <iostream>
      int main()
      {
        std::cout << "Hello, world!" << std::endl;
        return 0;
      }
    EOS
    system "#{bin}/g++-7", "-o", "hello-cc", "hello-cc.cc"
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
    system "#{bin}/gfortran-7", "-o", "test", "test.f90"
    assert_equal "Done\n", `./test`
  end
end

__END__
diff --git a/gcc/graphite.h b/gcc/graphite.h
index 578fa1a..e4fad06 100644
--- a/gcc/graphite.h
+++ b/gcc/graphite.h
@@ -37,6 +37,8 @@ along with GCC; see the file COPYING3.  If not see
 #include <isl/schedule.h>
 #include <isl/ast_build.h>
 #include <isl/schedule_node.h>
+#include <isl/id.h>
+#include <isl/space.h>

 typedef struct poly_dr *poly_dr_p;
