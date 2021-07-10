class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/0.9.2.tar.gz"
  sha256 "01844552ae1a23b36bea291281f5fb0f1336b9a110caad8810e835ccea53dddc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3f9d362f0c165806c92a63f6f36f899eda286a82ee5da39fea8ca66db23a816" # linuxbrew-core
  end

  depends_on "lua"

  def install
    system "make", "fennel"
    bin.install "fennel"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
