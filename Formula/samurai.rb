# samurai: Build a bottle for Linux
class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/0.7/samurai-0.7.tar.gz"
  sha256 "e079e8de3b07ba0f1fffe2dff31c1fcb3be357c523abc6937108635a081a11f0"
  head "https://github.com/michaelforney/samurai.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a87ae50760da90b1e6c90cbd1ed02668ffb8fb5caf0204140cbb8979da939c1" => :catalina
    sha256 "6f1466c677e072d7951186addb8f10c2c9982e304f7e02e18a66c6b8614f4677" => :mojave
    sha256 "8c449b4e0f2bf0e14491de294221a5f8135db8cb2392aebd24ae6f72deba1405" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      rule cc
        command = #{ENV.cc} $in -o $out
      build hello: cc hello.c
    EOS
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system bin/"samu"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
