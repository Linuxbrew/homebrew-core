# fonttools: Build a bottle for Linux
class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.0/fonttools-4.2.0.zip"
  sha256 "9bcc7b55d9f06e2398a98f5b3e9a6221ca2f819c670e3dd2e5895829ca375e5f"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6701c36434bc23a000ae74a7de1dabcc8c79d7836371753e09eb6cafbec654e" => :catalina
    sha256 "5035ac87ae08d70002d9876343308d478066f2e65fac5af2185abc5c53d17b8d" => :mojave
    sha256 "327fcdd17de25dfc9ffb10bba1d9ab235827b0d3361d2371f5f763c348ed5327" => :high_sierra
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    unless OS.mac?
      assert_match "usage", shell_output("#{bin}/ttx -h")
      return
    end
    cp "/System/Library/Fonts/ZapfDingbats.ttf", testpath
    system bin/"ttx", "ZapfDingbats.ttf"
  end
end
