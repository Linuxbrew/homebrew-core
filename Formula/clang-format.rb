class ClangFormat < Formula
  desc "Formatting tools for C, C++, Obj-C, Java, JavaScript, TypeScript"
  homepage "https://clang.llvm.org/docs/ClangFormat.html"
  version_scheme 1

  stable do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/llvm-10.0.0.src.tar.xz"
    sha256 "df83a44b3a9a71029049ec101fb0077ecbbdf5fe41e395215025779099a98fdf"

    resource "clang" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/clang-10.0.0.src.tar.xz"
      sha256 "885b062b00e903df72631c5f98b9579ed1ed2790f74e5646b4234fa084eacb21"
    end

    resource "libcxx" do
      url "https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.0/libcxx-10.0.0.src.tar.xz"
      sha256 "270f8a3f176f1981b0f6ab8aa556720988872ec2b48ed3b605d0ced8d09156c7"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a2d877df6d298cba78b2ea3e543b5a874cf7af853538d9e1ae4b74b5f69bb65" => :catalina
    sha256 "91e010b88d1779626bd693c6df0da1e10156887bc5bc2d3ed6500965ea66ec96" => :mojave
    sha256 "dc9b3fe7f1b043286fb5554d26a70defabf0aa668b2861624451005c9593eca3" => :high_sierra
    sha256 "0d8f5ada639dfdcd66d7dd6d8eca52b859d7d9a4fc09aad30759db6868dad94b" => :x86_64_linux
  end

  head do
    url "https://git.llvm.org/git/llvm.git"

    resource "clang" do
      url "https://git.llvm.org/git/clang.git"
    end

    resource "libcxx" do
      url "https://git.llvm.org/git/libcxx.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "subversion" => :build
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "gcc" # needed for libstdc++
    depends_on "glibc" if Formula["glibc"].installed? || OS::Linux::Glibc.system_version < Formula["glibc"].version
    depends_on "libedit" # llvm requires <histedit.h>
  end

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    if build.head?
      ln_s buildpath/"libcxx", buildpath/"llvm/projects/libcxx" if OS.mac?
      ln_s buildpath/"clang", buildpath/"llvm/tools/clang"
    else
      (buildpath/"projects/libcxx").install resource("libcxx") if OS.mac?
      (buildpath/"tools/clang").install resource("clang")
    end

    llvmpath = build.head? ? buildpath/"llvm" : buildpath

    mkdir llvmpath/"build" do
      args = std_cmake_args
      args << "-DLLVM_ENABLE_LIBCXX=ON" if OS.mac?
      args << "-DLLVM_ENABLE_LIBCXX=OFF" unless OS.mac?
      args << ".."
      system "cmake", "-G", "Ninja", *args
      system "ninja", "clang-format"
    end

    bin.install llvmpath/"build/bin/clang-format"
    bin.install llvmpath/"tools/clang/tools/clang-format/git-clang-format"
    (share/"clang").install Dir[llvmpath/"tools/clang/tools/clang-format/clang-format*"]
  end

  test do
    # NB: below C code is messily formatted on purpose.
    (testpath/"test.c").write <<~EOS
      int         main(char *args) { \n   \t printf("hello"); }
    EOS

    assert_equal "int main(char *args) { printf(\"hello\"); }\n",
        shell_output("#{bin}/clang-format -style=Google test.c")
  end
end
