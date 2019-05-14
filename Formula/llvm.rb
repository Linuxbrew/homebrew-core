# llvm: Build a bottle for Linuxbrew
require "os/linux/glibc"

class Llvm < Formula
  desc "Next-gen compiler infrastructure"
  homepage "https://llvm.org/"

  stable do
    url "https://releases.llvm.org/8.0.0/llvm-8.0.0.src.tar.xz"
    sha256 "8872be1b12c61450cacc82b3d153eab02be2546ef34fa3580ed14137bb26224c"

    resource "clang" do
      url "https://releases.llvm.org/8.0.0/cfe-8.0.0.src.tar.xz"
      sha256 "084c115aab0084e63b23eee8c233abb6739c399e29966eaeccfc6e088e0b736b"

      patch do
        url "https://gist.githubusercontent.com/iMichka/https://gist.githubusercontent.com/iMichka/a5d88f6bbe1f62fc43dc040282234452/raw/430616d646260e47360d9cba0901ac2876007350/clang8?full_index=1"
        sha256 "a7403c5a3ea2edddb7c1cb70274396f4c31d6b7c37aa1e4e4edaca3d1b78300f"
      end unless OS.mac?
    end

    resource "clang-extra-tools" do
      url "https://releases.llvm.org/8.0.0/clang-tools-extra-8.0.0.src.tar.xz"
      sha256 "4f00122be408a7482f2004bcf215720d2b88cf8dc78b824abb225da8ad359d4b"
    end

    resource "compiler-rt" do
      url "https://releases.llvm.org/8.0.0/compiler-rt-8.0.0.src.tar.xz"
      sha256 "b435c7474f459e71b2831f1a4e3f1d21203cb9c0172e94e9d9b69f50354f21b1"
    end

    resource "libcxx" do
      url "https://releases.llvm.org/8.0.0/libcxx-8.0.0.src.tar.xz"
      sha256 "c2902675e7c84324fb2c1e45489220f250ede016cc3117186785d9dc291f9de2"
    end

    resource "libcxxabi" do
      url "https://llvm.org/releases/6.0.1/libcxxabi-6.0.1.src.tar.xz"
      sha256 "209f2ec244a8945c891f722e9eda7c54a5a7048401abd62c62199f3064db385f"
    end

    resource "libunwind" do
      url "https://releases.llvm.org/8.0.0/libunwind-8.0.0.src.tar.xz"
      sha256 "ff243a669c9cef2e2537e4f697d6fb47764ea91949016f2d643cb5d8286df660"
    end

    resource "lld" do
      url "https://releases.llvm.org/8.0.0/lld-8.0.0.src.tar.xz"
      sha256 "9caec8ec922e32ffa130f0fb08e4c5a242d7e68ce757631e425e9eba2e1a6e37"
    end

    resource "lldb" do
      url "https://releases.llvm.org/8.0.0/lldb-8.0.0.src.tar.xz"
      sha256 "49918b9f09816554a20ac44c5f85a32dc0a7a00759b3259e78064d674eac0373"
    end

    resource "openmp" do
      url "https://releases.llvm.org/8.0.0/openmp-8.0.0.src.tar.xz"
      sha256 "f7b1705d2f16c4fc23d6531f67d2dd6fb78a077dd346b02fed64f4b8df65c9d5"
    end

    resource "polly" do
      url "https://releases.llvm.org/8.0.0/polly-8.0.0.src.tar.xz"
      sha256 "e3f5a3d6794ef8233af302c45ceb464b74cdc369c1ac735b6b381b21e4d89df4"
    end
  end

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    rebuild 1
    sha256 "6a44cd91d7e3b01fef214c31e736c77cfb681d2d0e6e576ab725c8071858a36d" => :mojave
    sha256 "d92a2a8b0066e2b70190d59cc980a12a2362b56f9100c7ef4051dc08e762c52e" => :high_sierra
    sha256 "168806783f260662a1bb126f300c21060fbf24d01424fd8e64cc5c54e2c81b9c" => :sierra
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

      patch do
        url "https://gist.githubusercontent.com/iMichka/027fd3d17b4c729e73a190ae29e44b47/raw/a88c628f28ca9cd444cc3771072260fe46ff8a29/llvm7.patch?full_index=1"
        sha256 "8db2acff4fbe0533667c9a0527a6a180fd2a84daea4271665fd42f88a08eaa86"
      end unless OS.mac?
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
  depends_on "swig" if MacOS.version >= :lion

  unless OS.mac?
    depends_on "gcc" # needed for libstdc++
    depends_on "glibc" => (Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version) ? :recommended : :optional
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
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j2 -l2.0" if ENV["CIRCLECI"]

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
      # Remove conflicting libraries.
      # libgomp.so conflicts with gcc.
      rm lib/"libgomp.so"

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

    # link against installed libc++
    # related to https://github.com/Homebrew/legacy-homebrew/issues/47149
    if OS.mac?
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
