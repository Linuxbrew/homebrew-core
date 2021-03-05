class Bear < Formula
  include Language::Python::Shebang

  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/3.0.8.tar.gz"
  sha256 "663ef2fcf359e1efb20831fae3901a3edbbb906dd0bc5e62af92e353651c5cec"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    sha256 arm64_big_sur: "deef28d5dbc2df3e1f7fced4ca1077e5bc0cb910071a45e9818aa47e1b8d747e"
    sha256 big_sur:       "b0bc47161d069264bf9f3ea3bf0fe66fd0fcfb22813fda0742824a4fa013bc64"
    sha256 catalina:      "aa944713b632a387c76ed5f6d98eb512859dc6a7920a82338199000aff49628b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "grpc"
  depends_on macos: :catalina
  depends_on "nlohmann-json"
  depends_on "python@3.9"
  depends_on "spdlog"
  depends_on "sqlite"

  unless OS.mac?
    fails_with gcc: "5"
    fails_with gcc: "9"
    depends_on "gcc"
    depends_on "llvm"
  end

  def install
    args = std_cmake_args + %w[
      -DENABLE_UNIT_TESTS=OFF
      -DENABLE_FUNC_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "all"
      system "make", "install"
    end

    rewrite_shebang detected_python_shebang, bin/"bear"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main() {
        printf("hello, world!\\n");
        return 0;
      }
    EOS
    system "#{bin}/bear", "--", "clang", "test.c"
    assert_predicate testpath/"compile_commands.json", :exist?
  end
end
