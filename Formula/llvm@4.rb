require "os/linux/glibc"

class LlvmAT4 < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"
  url "https://releases.llvm.org/4.0.1/llvm-4.0.1.src.tar.xz"
  sha256 "da783db1f82d516791179fe103c71706046561f7972b18f0049242dee6712b51"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "71636f7639720777e3e26c6d06456706cc79ad9bac08ba9d9100becfb903b210" => :mojave
    sha256 "acd6bae928b7a8d339b500e1571bc691e2bcfabfd08b6c9c74ff6ef962a2bbe4" => :high_sierra
    sha256 "e240000e773bbd10c9aac0eba8b510137a43929100b20b56e440ebca14dc7276" => :sierra
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX}."
    satisfy { OS.mac? || HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "libffi"

  unless OS.mac?
    depends_on "gcc" # <atomic> is provided by gcc
    depends_on "glibc" => (Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version) ? :recommended : :optional
    depends_on "binutils" # needed for gold and strip
    depends_on "libedit" # llvm requires <histedit.h>
    depends_on "ncurses"
    depends_on "libxml2"
    depends_on "python@2"
    depends_on "zlib"
  end

  resource "clang" do
    url "https://releases.llvm.org/4.0.1/cfe-4.0.1.src.tar.xz"
    sha256 "61738a735852c23c3bdbe52d035488cdb2083013f384d67c1ba36fabebd8769b"
  end

  resource "clang-extra-tools" do
    url "https://releases.llvm.org/4.0.1/clang-tools-extra-4.0.1.src.tar.xz"
    sha256 "35d1e64efc108076acbe7392566a52c35df9ec19778eb9eb12245fc7d8b915b6"
  end

  resource "compiler-rt" do
    url "https://releases.llvm.org/4.0.1/compiler-rt-4.0.1.src.tar.xz"
    sha256 "a3c87794334887b93b7a766c507244a7cdcce1d48b2e9249fc9a94f2c3beb440"

    unless OS.mac?
      # Fix sanitizer_common and tsan for glibc 2.26 and above.
      patch do
        url "https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68de4d2c80ff00a97bbcb3722a4716da.patch?full_index=1"
        sha256 "1b2116421205097a22ba75e5ef4b7c63256aac3374e47efafaa1e324755060e4"
      end

      # Fix esan and tsan for glibc 2.26 and above.
      patch do
        url "https://github.com/llvm-mirror/compiler-rt/commit/78162497aa177b34956aee0458e09d8b97b5dd2b.patch?full_index=1"
        sha256 "1922e76683dc21541cdae2562a7fab786b02b685cc088c9b66c04b3d738be873"
      end
    end
  end

  resource "libcxx" do
    url "https://releases.llvm.org/4.0.1/libcxx-4.0.1.src.tar.xz"
    sha256 "520a1171f272c9ff82f324d5d89accadcec9bc9f3c78de11f5575cdb99accc4c"
  end

  resource "libunwind" do
    url "https://releases.llvm.org/4.0.1/libunwind-4.0.1.src.tar.xz"
    sha256 "3b072e33b764b4f9b5172698e080886d1f4d606531ab227772a7fc08d6a92555"
  end

  resource "lld" do
    url "https://releases.llvm.org/4.0.1/lld-4.0.1.src.tar.xz"
    sha256 "63ce10e533276ca353941ce5ab5cc8e8dcd99dbdd9c4fa49f344a212f29d36ed"
  end

  resource "lldb" do
    url "https://releases.llvm.org/4.0.1/lldb-4.0.1.src.tar.xz"
    sha256 "8432d2dfd86044a0fc21713e0b5c1d98e1d8aad863cf67562879f47f841ac47b"
  end

  resource "openmp" do
    url "https://releases.llvm.org/4.0.1/openmp-4.0.1.src.tar.xz"
    sha256 "ec693b170e0600daa7b372240a06e66341ace790d89eaf4a843e8d56d5f4ada4"
  end

  resource "polly" do
    url "https://releases.llvm.org/4.0.1/polly-4.0.1.src.tar.xz"
    sha256 "b443bb9617d776a7d05970e5818aa49aa2adfb2670047be8e9f242f58e84f01a"
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j5" if ENV["CIRCLECI"]

    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    unless OS.mac?
      # Add glibc to the list of library directories so that we won't have to do -L<path-to-glibc>/lib
      inreplace buildpath/"tools/clang/lib/Driver/ToolChains.cpp",
      "// Add the multilib suffixed paths where they are available.",
      "addPathIfExists(D, \"#{HOMEBREW_PREFIX}/opt/glibc/lib\", Paths);\n\n  // Add the multilib suffixed paths where they are available."
    end
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx") if OS.mac?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    args = %W[
      -DLIBOMP_ARCH=x86_64
      -DLINK_POLLY_INTO_TOOLS=ON
      -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON
      -DLLVM_BUILD_LLVM_DYLIB=ON
      -DLLVM_ENABLE_EH=ON
      -DLLVM_ENABLE_FFI=ON
      -DLLVM_ENABLE_RTTI=ON
      -DLLVM_INCLUDE_DOCS=OFF
      -DLLVM_INSTALL_UTILS=ON
      -DLLVM_OPTIMIZED_TABLEGEN=ON
      -DLLVM_TARGETS_TO_BUILD=all
      -DWITH_POLLY=ON
      -DFFI_INCLUDE_DIR=#{Formula["libffi"].opt_lib}/libffi-#{Formula["libffi"].version}/include
      -DFFI_LIBRARY_DIR=#{Formula["libffi"].opt_lib}
    ]

    if OS.mac?
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=ON"
      args << "-DLLVM_ENABLE_LIBCXX=ON"
    else
      args << "-DLLVM_CREATE_XCODE_TOOLCHAIN=OFF"
      args << "-DLLVM_ENABLE_LIBCXX=OFF"
      args << "-DCLANG_DEFAULT_CXX_STDLIB=libstdc++"
    end

    # Enable llvm gold plugin for LTO
    args << "-DLLVM_BINUTILS_INCDIR=#{Formula["binutils"].opt_include}" unless OS.mac?

    # Help just-built clang++ find <atomic> (and, possibly, other header files). Needed for compiler-rt
    unless OS.mac?
      gccpref = Formula["gcc"].opt_prefix.to_s
      args << "-DGCC_INSTALL_PREFIX=#{gccpref}"
      args << "-DCMAKE_C_COMPILER=#{gccpref}/bin/gcc"
      args << "-DCMAKE_CXX_COMPILER=#{gccpref}/bin/g++"
      args << "-DCMAKE_CXX_LINK_FLAGS=-L#{gccpref}/lib64 -Wl,-rpath,#{gccpref}/lib64"
    end

    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if OS.mac?
    end

    (share/"cmake").install "cmake/modules"
    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]

    # scan-build is in Perl, so the @ in our path needs to be escaped
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build",
              "$RealBin/bin/clang", "#{bin}/clang".gsub("@", "\\@")

    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"

    # Remove conflicting libraries.
    # libgomp.so conflicts with gcc.
    # libunwind.so conflcits with libunwind.
    rm [lib/"libgomp.so", lib/"libunwind.so"] if OS.linux?

    # Strip executables/libraries/object files to reduce their size
    unless OS.mac?
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  test do
    assert_equal prefix.to_s, shell_output("#{bin}/llvm-config --prefix").chomp

    (testpath/"omptest.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <omp.h>

      int main() {
          #pragma omp parallel num_threads(4)
          {
            printf("Hello from thread %d, nthreads %d\\n", omp_get_thread_num(), omp_get_num_threads());
          }
          return EXIT_SUCCESS;
      }
    EOS

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{version}/include",
                           *("-Wl,-rpath=#{lib}" unless OS.mac?),
                           "omptest.c", "-o", "omptest"
    testresult = shell_output("./omptest")

    sorted_testresult = testresult.split("\n").sort.join("\n")
    expected_result = <<~EOS
      Hello from thread 0, nthreads 4
      Hello from thread 1, nthreads 4
      Hello from thread 2, nthreads 4
      Hello from thread 3, nthreads 4
    EOS
    assert_equal expected_result.strip, sorted_testresult.strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>

      int main()
      {
        printf("Hello World!\\n");
        return 0;
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>

      int main()
      {
        std::cout << "Hello World!" << std::endl;
        return 0;
      }
    EOS

    # Testing Command Line Tools
    if OS.mac? && MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I/usr/include", # this is where CLT installs stdio.h
              "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if OS.mac? && MacOS::Xcode.installed?
      libclangxc = Dir["#{MacOS::Xcode.toolchain_path}/usr/lib/clang/#{DevelopmentTools.clang_version}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp

      system "#{bin}/clang", "-v", "-nostdinc",
              "-I#{MacOS.sdk_path}/usr/include",
              "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    if OS.mac?
      # link against installed libc++
      # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
      system "#{bin}/clang++", "-v", "-nostdinc",
              "-std=c++11", "-stdlib=libc++",
              "-I#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
              "-I#{libclangxc}/include",
              "-I#{MacOS.sdk_path}/usr/include",
              "-L#{lib}",
              "-Wl,-rpath,#{lib}", "test.cpp", "-o", "test"
      assert_includes MachO::Tools.dylibs("test"), "#{opt_lib}/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./test").chomp
    end
  end
end
