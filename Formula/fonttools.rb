class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.8.1/fonttools-4.8.1.zip"
  sha256 "596c0e8399c650dbf1048b7ca6fc7b12bd79a7db0981f3b87743de8c2b7512de"
  revision 1 unless OS.mac?
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4ca3c0eee1bc93498a7ee79f252b3480f6e609b514076049ff4840eea4b10f7" => :catalina
    sha256 "00b4e22d111ec55c0e316ac1ff4f45e98dcdf7a344cdbfc57ebadeff26f31310" => :mojave
    sha256 "a5c01ccf14a250209d02bbbefa49c0be21ac7b8a9e85f70b8258a1716a44ceb4" => :high_sierra
  end

  depends_on "python@3.8"

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
