# llvm: Build a bottle for Linux
require "os/linux/glibc"

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/llvm-9.0.1.src.tar.xz"
    sha256 "00a1ee1f389f81e9979f3a640a01c431b3021de0d42278f6508391a2f0b81c9a"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-9.0.1.src.tar.xz"
      sha256 "5778512b2e065c204010f88777d44b95250671103e434f9dc7363ab2e3804253"

      unless OS.mac?
        patch do
          url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
          sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        end
      end
    end

    resource "clang-extra-tools" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/clang-tools-extra-9.0.1.src.tar.xz"
      sha256 "b26fd72a78bd7db998a26270ec9ec6a01346651d88fa87b4b323e13049fb6f07"
    end

    resource "compiler-rt" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/compiler-rt-9.0.1.src.tar.xz"
      sha256 "c2bfab95c9986318318363d7f371a85a95e333bc0b34fbfa52edbd3f5e3a9077"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/libcxx-9.0.1.src.tar.xz"
      sha256 "0981ff11b862f4f179a13576ab0a2f5530f46bd3b6b4a90f568ccc6a62914b34"
    end

    resource "libcxxabi" do
      url "https://llvm.org/releases/6.0.1/libcxxabi-6.0.1.src.tar.xz"
      sha256 "209f2ec244a8945c891f722e9eda7c54a5a7048401abd62c62199f3064db385f"
    end

    resource "libunwind" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/libunwind-9.0.1.src.tar.xz"
      sha256 "535a106a700889274cc7b2f610b2dcb8fc4b0ea597c3208602d7d037141460f1"
    end

    resource "lld" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/lld-9.0.1.src.tar.xz"
      sha256 "86262bad3e2fd784ba8c5e2158d7aa36f12b85f2515e95bc81d65d75bb9b0c82"
    end

    resource "lldb" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/lldb-9.0.1.src.tar.xz"
      sha256 "8a7b9fd795c31a3e3cba6ce1377a2ae5c67376d92888702ce27e26f0971beb09"
    end

    resource "openmp" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/openmp-9.0.1.src.tar.xz"
      sha256 "5c94060f846f965698574d9ce22975c0e9f04c9b14088c3af5f03870af75cace"
    end

    resource "polly" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-9.0.1/polly-9.0.1.src.tar.xz"
      sha256 "9a4ac69df923230d13eb6cd0d03f605499f6a854b1dc96a9b72c4eb075040fcf"
    end
  end

  bottle do
    cellar :any
    sha256 "6964572246daac37b921125f1d8f60da8c2c626b54e289ff9b015725bfa3a9ea" => :catalina
    sha256 "13848a9e23a94df2468b931ae84ae72bb257fba6d2d67b94db59de308f0735ee" => :mojave
    sha256 "a68c82c388558bce245e4d7cee532cb7f8d743a02ed77c4add2867b905b6d6b5" => :high_sierra
  end

  # Clang cannot find system headers if Xcode CLT is not installed
  pour_bottle? do
    reason "The bottle needs the Xcode CLT to be installed."
    satisfy { !OS.mac? || MacOS::CLT.installed? }
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"

      unless OS.mac?
        patch do
          url "https://gist.githubusercontent.com/iMichka/9ac8e228679a85210e11e59d029217c1/raw/e50e47df860201589e6f43e9f8e9a4fc8d8a972b/clang9?full_index=1"
          sha256 "65cf0dd9fdce510e74648e5c230de3e253492b8f6793a89534becdb13e488d0c"
        end
      end
    end

    resource "clang-extra-tools" do
      url "https://git.llvm.org/git/clang-tools-extra.git"
    end

    resource "compiler-rt" do
      url "https://git.llvm.org/git/compiler-rt.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end

    resource "libcxxabi" do
      url "http://llvm.org/git/libcxxabi.git"
    end

    resource "libunwind" do
      url "https://git.llvm.org/git/libunwind.git"
    end

    resource "lld" do
      url "https://git.llvm.org/git/lld.git"
    end

    resource "lldb" do
      url "https://git.llvm.org/git/lldb.git"
    end

    resource "openmp" do
      url "https://git.llvm.org/git/openmp.git"
    end

    resource "polly" do
      url "https://git.llvm.org/git/polly.git"
    end
  end

  keg_only :provided_by_macos

  # https://llvm.org/docs/GettingStarted.html#requirement
  depends_on "cmake" => :build
  depends_on :xcode => :build if OS.mac?
  depends_on "libffi"
  depends_on "swig"

  unless OS.mac?
    depends_on "gcc" # needed for libstdc++
    depends_on "glibc" if Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version
    depends_on "binutils" # needed for gold and strip
    depends_on "libedit" # llvm requires <histedit.h>
    depends_on "libelf" # openmp requires <gelf.h>
    depends_on "ncurses"
    depends_on "libxml2"
    depends_on "zlib"
    depends_on "python@2"

    conflicts_with "clang-format", :because => "both install `clang-format` binaries"
  end

  def install
    # Apple's libstdc++ is too old to build LLVM
    ENV.libcxx if ENV.compiler == :clang

    (buildpath/"tools/clang").install resource("clang")
    (buildpath/"tools/clang/tools/extra").install resource("clang-extra-tools")
    (buildpath/"projects/openmp").install resource("openmp")
    (buildpath/"projects/libcxx").install resource("libcxx") if OS.mac?
    (buildpath/"projects/libunwind").install resource("libunwind")
    (buildpath/"tools/lld").install resource("lld")
    (buildpath/"tools/lldb").install resource("lldb")
    (buildpath/"tools/polly").install resource("polly")
    (buildpath/"projects/compiler-rt").install resource("compiler-rt")

    # compiler-rt has some iOS simulator features that require i386 symbols
    # I'm assuming the rest of clang needs support too for 32-bit compilation
    # to work correctly, but if not, perhaps universal binaries could be
    # limited to compiler-rt. llvm makes this somewhat easier because compiler-rt
    # can almost be treated as an entirely different build from llvm.
    ENV.permit_arch_flags

    unless OS.mac?
      # see https://llvm.org/docs/HowToCrossCompileBuiltinsOnArm.html#the-cmake-try-compile-stage-fails
      # Basically, the stage1 clang will try to locate a gcc toolchain and often
      # get the default from /usr/local, which might contains an old version of
      # gcc that can't build compiler-rt. This fixes the problem and, unlike
      # setting the main project's cmake option -DGCC_INSTALL_PREFIX, avoid
      # hardcoding the gcc path into the binary
      inreplace "projects/compiler-rt/CMakeLists.txt", /(cmake_minimum_required.*\n)/,
        "\\1add_compile_options(\"--gcc-toolchain=#{Formula["gcc"].opt_prefix}\")"
    end

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
      -DLLDB_USE_SYSTEM_DEBUGSERVER=ON
      -DLLDB_DISABLE_PYTHON=1
      -DLIBOMP_INSTALL_ALIASES=OFF
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

    mkdir "build" do
      if MacOS.version >= :mojave
        sdk_path = MacOS::CLT.installed? ? "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" : MacOS.sdk_path
        args << "-DDEFAULT_SYSROOT=#{sdk_path}"
      end

      system "cmake", "-G", "Unix Makefiles", "..", *(std_cmake_args + args)
      system "make"
      system "make", "install"
      system "make", "install-xcode-toolchain" if OS.mac?
    end

    (share/"clang/tools").install Dir["tools/clang/tools/scan-{build,view}"]
    (share/"cmake").install "cmake/modules"
    inreplace "#{share}/clang/tools/scan-build/bin/scan-build", "$RealBin/bin/clang", "#{bin}/clang"
    bin.install_symlink share/"clang/tools/scan-build/bin/scan-build", share/"clang/tools/scan-view/bin/scan-view"
    man1.install_symlink share/"clang/tools/scan-build/man/scan-build.1"

    # install llvm python bindings
    (lib/"python2.7/site-packages").install buildpath/"bindings/python/llvm"
    (lib/"python2.7/site-packages").install buildpath/"tools/clang/bindings/python/clang"

    unless OS.mac?
      # Strip executables/libraries/object files to reduce their size
      system("strip", "--strip-unneeded", "--preserve-dates", *(Dir[bin/"**/*", lib/"**/*"]).select do |f|
        f = Pathname.new(f)
        f.file? && (f.elf? || f.extname == ".a")
      end)
    end
  end

  def caveats; <<~EOS
    To use the bundled libc++ please add the following LDFLAGS:
      LDFLAGS="-L#{opt_lib} -Wl,-rpath,#{opt_lib}"
  EOS
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

    clean_version = version.to_s[/(\d+\.?)+/]

    system "#{bin}/clang", "-L#{lib}", "-fopenmp", "-nobuiltininc",
                           "-I#{lib}/clang/#{clean_version}/include",
                           "omptest.c", "-o", "omptest", *ENV["LDFLAGS"].split
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

    unless OS.mac?
      system "#{bin}/clang++", "-v", "test.cpp", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp
    end

    # Testing Command Line Tools
    if OS.mac? && MacOS::CLT.installed?
      libclangclt = Dir["/Library/Developer/CommandLineTools/usr/lib/clang/#{MacOS::CLT.version.to_i}*"].last { |f| File.directory? f }

      system "#{bin}/clang++", "-v", "-nostdinc",
              "-I/Library/Developer/CommandLineTools/usr/include/c++/v1",
              "-I#{libclangclt}/include",
              "-I/usr/include", # need it because /Library/.../usr/include/c++/v1/iosfwd refers to <wchar.h>, which CLT installs to /usr/include
              "test.cpp", "-o", "testCLT++"
      # Testing default toolchain and SDK location.
      system "#{bin}/clang++", "-v",
             "-std=c++11", "test.cpp", "-o", "test++"
      assert_includes MachO::Tools.dylibs("test++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./test++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "test"
      assert_equal "Hello World!", shell_output("./test").chomp

      toolchain_path = "/Library/Developer/CommandLineTools"
      sdk_path = "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"
      system "#{bin}/clang++", "-v",
             "-isysroot", sdk_path,
             "-isystem", "#{toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{toolchain_path}/usr/include",
             "-isystem", "#{sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testCLT++"
      assert_includes MachO::Tools.dylibs("testCLT++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testCLT++").chomp
      system "#{bin}/clang", "-v", "test.c", "-o", "testCLT"
      assert_equal "Hello World!", shell_output("./testCLT").chomp
    end

    # Testing Xcode
    if OS.mac? && MacOS::Xcode.installed?
      system "#{bin}/clang++", "-v",
             "-isysroot", MacOS.sdk_path,
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include/c++/v1",
             "-isystem", "#{MacOS::Xcode.toolchain_path}/usr/include",
             "-isystem", "#{MacOS.sdk_path}/usr/include",
             "-std=c++11", "test.cpp", "-o", "testXC++"
      assert_includes MachO::Tools.dylibs("testXC++"), "/usr/lib/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testXC++").chomp
      system "#{bin}/clang", "-v",
             "-isysroot", MacOS.sdk_path,
             "test.c", "-o", "testXC"
      assert_equal "Hello World!", shell_output("./testXC").chomp
    end

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if OS.mac?
      system "#{bin}/clang++", "-v",
             "-isystem", "#{opt_include}/c++/v1",
             "-std=c++11", "-stdlib=libc++", "test.cpp", "-o", "testlibc++",
             "-L#{opt_lib}", "-Wl,-rpath,#{opt_lib}"
      assert_includes MachO::Tools.dylibs("testlibc++"), "#{opt_lib}/libc++.1.dylib"
      assert_equal "Hello World!", shell_output("./testlibc++").chomp

      (testpath/"scanbuildtest.cpp").write <<~EOS
        #include <iostream>
        int main() {
          int *i = new int;
          *i = 1;
          delete i;
          std::cout << *i << std::endl;
          return 0;
        }
      EOS
      assert_includes shell_output("#{bin}/scan-build clang++ scanbuildtest.cpp 2>&1"),
        "warning: Use of memory after it is freed"

      (testpath/"clangformattest.c").write <<~EOS
        int    main() {
            printf("Hello world!"); }
      EOS
      assert_equal "int main() { printf(\"Hello world!\"); }\n",
      shell_output("#{bin}/clang-format -style=google clangformattest.c")
    end
  end
end
