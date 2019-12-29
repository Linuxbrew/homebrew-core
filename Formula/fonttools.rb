# fonttools: Build a bottle for Linux
class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/4.2.2/fonttools-4.2.2.zip"
  sha256 "66bb3dfe7efe5972b0145339c063ffaf9539e973f7ff8791df84366eafc65804"
  revision 1
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dd9cf2664da6e6f2856aa22c198ffe8771d759eeab92c73533939bd15385256c" => :catalina
    sha256 "ae216d8be51bda5c55acee93cc957389f0f2d527bfaea897ce2743d3e9989994" => :mojave
    sha256 "70745e14602de083a80f93f65416e24069882311a34a9e348f085b2c8ccb4dec" => :high_sierra
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
