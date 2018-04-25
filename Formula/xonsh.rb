# xonsh: Build a bottle for Linuxbrew
class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-ish, BASHwards-compatible shell language and command prompt"
  homepage "http://xon.sh"
  url "https://github.com/xonsh/xonsh/archive/0.6.2.tar.gz"
  sha256 "b5c221476d02b013965b715950b4b9ee8c8cec423db82e219a09d69215d4b0a4"
  head "https://github.com/scopatz/xonsh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0245f17bd330d3d60f1b3e85746a73090bbf9a5580921fb470a6c4810ee7856" => :x86_64_linux
  end

  depends_on "python"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
