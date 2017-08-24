class Gcc < Formula
  def arch
    if MacOS.prefer_64_bit?
      "x86_64"
    else
      "i686"
    end
  end

  def osmajor
    `uname -r`.chomp
  end

  desc "GNU compiler collection"
  homepage "https://gcc.gnu.org/"

  head "svn://gcc.gnu.org/svn/gcc/trunk"

  stable do
    if OS.mac?
      url "https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
      mirror "https://ftpmirror.gnu.org/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
      sha256 "1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a"
    else
      url "http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2"
      mirror "https://ftp.gnu.org/gnu/gcc/gcc-5.3.0/gcc-5.3.0.tar.bz2"
      sha256 "b84f5592e9218b73dbae612b5253035a7b34a9a1f7688d2e1bfaaf7267d5c4db"
    end
  end

  bottle do
    cellar :any if OS.linux?
    sha256 "bc96bddd0e9f7c074eab7c4036973bc60d5d5ef4489e65db64018363d63d248d" => :sierra
    sha256 "755ed27d3aa9b60523aead68f36d17f6396b9f4b622a0972c05eae3302922d5c" => :el_capitan
    sha256 "eecedf7c9233bd1553d3e22027f415f15a9d1a7ad11e486855bf3a8f7d36ed23" => :yosemite
    sha256 "2c6ae8e098830e19f87d8426b49d353b6cbc0b89d9259bae242d57b6694c9039" => :x86_64_linux
  end

  # GCC's Go compiler is not currently supported on macOS.
  # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=46986
  option "with-java", "Build the gcj compiler"
  option "with-all-languages", "Enable all compilers and languages, except Ada"
  option "with-nls", "Build with native language support (localization)"
  option "with-jit", "Build the jit compiler"
  option "without-fortran", "Build without the gfortran compiler"

  depends_on "zlib" unless OS.mac?
  depends_on "binutils" if build.with? "glibc"
  depends_on "glibc" => (Formula["glibc"].installed? || OS.linux? && !GlibcRequirement.new.satisfied?) ? :recommended : :optional
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "isl"
  depends_on "ecj" if build.with?("java") || build.with?("all-languages")

  fails_with :gcc_4_0

  # GCC bootstraps itself, so it is OK to have an incompatible C++ stdlib
  cxxstdlib_check :skip

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { MacOS::CLT.installed? }
  end

  def version_suffix
    if build.head?
      (stable.version.to_s.slice(/\d/).to_i + 1).to_s
    else
      version.to_s.slice(/\d/)
    end
  end

  # Fix for libgccjit.so linkage on Darwin
  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=64089
  patch :DATA if OS.mac?

  def install
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

      languages << "fortran" if build.with? "fortran"
      languages << "java" if build.with? "java"
      languages << "jit" if build.with? "jit"
    end

    args = []
    args << "--build=#{arch}-apple-darwin#{osmajor}" if OS.mac?
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
    args += [
      "--prefix=#{prefix}",
      ("--libdir=#{lib}/gcc/#{version_suffix}" if OS.mac?),
      "--enable-languages=#{languages.join(",")}",
      # Make most executables versioned to avoid conflicts.
      "--program-suffix=-#{version_suffix}",
      "--with-gmp=#{Formula["gmp"].opt_prefix}",
      "--with-mpfr=#{Formula["mpfr"].opt_prefix}",
      "--with-mpc=#{Formula["libmpc"].opt_prefix}",
      "--with-isl=#{Formula["isl"].opt_prefix}",
      "--with-system-zlib",
      "--enable-stage1-checking",
      "--enable-checking=release",
      "--enable-lto",
      # Use 'bootstrap-debug' build configuration to force stripping of object
      # files prior to comparison during bootstrap (broken by Xcode 6.3).
      "--with-build-config=bootstrap-debug",
      "--disable-werror",
      "--with-pkgversion=Homebrew #{name} #{pkg_version} #{build.used_options*" "}".strip,
      "--with-bugurl=https://github.com/Homebrew/homebrew/issues",
    ]

    # Fix cc1: error while loading shared libraries: libisl.so.15
    args << "--with-boot-ldflags=-static-libstdc++ -static-libgcc #{ENV["LDFLAGS"]}" if OS.linux?

    # The pre-Mavericks toolchain requires the older DWARF-2 debugging data
    # format to avoid failure during the stage 3 comparison of object files.
    # See: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=45248
    args << "--with-dwarf2" if OS.mac? && MacOS.version <= :mountain_lion

    args << "--disable-nls" if build.without? "nls"

    if build.with?("java") || build.with?("all-languages")
      args << "--with-ecj-jar=#{Formula["ecj"].opt_share}/java/ecj.jar"
    end

    args << "--enable-host-shared" if build.with?("jit") || build.with?("all-languages")

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

      if MacOS.prefer_64_bit?
        args << "--enable-multilib"
      else
        args << "--disable-multilib"
      end

      system "../configure", *args
      system "make", "bootstrap"
      system "make", "install"

      if build.with?("fortran") || build.with?("all-languages")
        bin.install_symlink bin/"gfortran-#{version_suffix}" => "gfortran"
      end

      if OS.linux?
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

    # Move lib64/* to lib/ on Linuxbrew
    lib64 = Pathname.new "#{lib}64"
    if lib64.directory?
      system "mv #{lib64}/* #{lib}/" # Do not use FileUtils.mv with Ruby 1.9.3
      rmdir lib64
      prefix.install_symlink "lib" => "lib64"
    end
  end

  def add_suffix(file, suffix)
    dir = File.dirname(file)
    ext = File.extname(file)
    base = File.basename(file, ext)
    File.rename file, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def post_install
    if OS.linux?
      # Create cc and c++ symlinks, unless they already exist
      homebrew_bin = Pathname.new "#{HOMEBREW_PREFIX}/bin"
      homebrew_bin.install_symlink "gcc" => "cc" unless (homebrew_bin/"cc").exist?
      homebrew_bin.install_symlink "g++" => "c++" unless (homebrew_bin/"c++").exist?

      # Create the GCC specs file
      # See https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html

      # Locate the specs file
      gcc = "gcc-#{version_suffix}"
      specs = Pathname.new(`#{bin}/#{gcc} -print-libgcc-file-name`).dirname/"specs"
      ohai "Creating the GCC specs file: #{specs}"
      raise "command failed: #{gcc} -print-libgcc-file-name" if $CHILD_STATUS.exitstatus.nonzero?
      specs_orig = Pathname.new("#{specs}.orig")
      rm_f [specs_orig, specs]

      # Save a backup of the default specs file
      specs_string = `#{bin}/#{gcc} -dumpspecs`
      raise "command failed: #{gcc} -dumpspecs" if $CHILD_STATUS.exitstatus.nonzero?
      specs_orig.write specs_string

      # Set the library search path
      glibc = Formula["glibc"]
      libgcc = lib/"gcc/x86_64-unknown-linux-gnu"/version
      specs.write specs_string + <<-EOS.undent
        *cpp_unique_options:
        + -isystem #{HOMEBREW_PREFIX}/include

        *link_libgcc:
        #{glibc.installed? ? "-nostdlib -L#{libgcc}" : "+"} -L#{HOMEBREW_PREFIX}/lib

        *link:
        + --dynamic-linker #{HOMEBREW_PREFIX}/lib/ld.so -rpath #{HOMEBREW_PREFIX}/lib

      EOS

      # Symlink ligcc_s.so.1 where glibc can find it.
      # Fix the error: libgcc_s.so.1 must be installed for pthread_cancel to work
      ln_sf opt_lib/"libgcc_s.so.1", glibc.lib if glibc.installed?
    end
  end

  test do
    (testpath/"hello-c.c").write <<-EOS.undent
      #include <stdio.h>
      int main()
      {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/gcc-#{version_suffix}", "-o", "hello-c", "hello-c.c"
    assert_equal "Hello, world!\n", `./hello-c`

    (testpath/"hello-cc.cc").write <<-EOS.undent
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
      fixture = <<-EOS.undent
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
__END__
diff --git a/gcc/jit/Make-lang.in b/gcc/jit/Make-lang.in
index 44d0750..4df2a9c 100644
--- a/gcc/jit/Make-lang.in
+++ b/gcc/jit/Make-lang.in
@@ -85,8 +85,7 @@ $(LIBGCCJIT_FILENAME): $(jit_OBJS) \
	     $(jit_OBJS) libbackend.a libcommon-target.a libcommon.a \
	     $(CPPLIB) $(LIBDECNUMBER) $(LIBS) $(BACKENDLIBS) \
	     $(EXTRA_GCC_OBJS) \
-	     -Wl,--version-script=$(srcdir)/jit/libgccjit.map \
-	     -Wl,-soname,$(LIBGCCJIT_SONAME)
+	     -Wl,-install_name,$(LIBGCCJIT_SONAME)

 $(LIBGCCJIT_SONAME_SYMLINK): $(LIBGCCJIT_FILENAME)
	ln -sf $(LIBGCCJIT_FILENAME) $(LIBGCCJIT_SONAME_SYMLINK)
diff --git a/gcc/jit/jit-playback.c b/gcc/jit/jit-playback.c
index 925fa86..01cfd4b 100644
--- a/gcc/jit/jit-playback.c
+++ b/gcc/jit/jit-playback.c
@@ -2416,6 +2416,15 @@ invoke_driver (const char *ctxt_progname,
      time.  */
   ADD_ARG ("-fno-use-linker-plugin");

+#if defined (DARWIN_X86) || defined (DARWIN_PPC)
+  /* OS X's linker defaults to treating undefined symbols as errors.
+     If the context has any imported functions or globals they will be
+     undefined until the .so is dynamically-linked into the process.
+     Ensure that the driver passes in "-undefined dynamic_lookup" to the
+     linker.  */
+  ADD_ARG ("-Wl,-undefined,dynamic_lookup");
+#endif
+
   /* pex argv arrays are NULL-terminated.  */
   argvec.safe_push (NULL);
