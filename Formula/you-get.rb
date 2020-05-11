class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://github.com/soimort/you-get/archive/v0.4.1432.tar.gz"
  sha256 "c35ebe75a2904f0dfcf75222109ee02e59aa45ade1105bdc15879cc1a0ae9264"
  revision 1 unless OS.mac?
  head "https://github.com/soimort/you-get.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "00978ff19ead4913f71581da459eedc79c51d51b3e3c2482db80cdba29e2bf3f" => :catalina
    sha256 "2baed6bb0c7bdba492eab79e19f267dae5a9c00d40ccdafcb230b2fa1b471cda" => :mojave
    sha256 "7e57020149ef1a994005275b9a09594d368f9ae59261fd4bb86a9386ba8e2ddd" => :high_sierra
    sha256 "9aebc5129f603b3faa2b504357a5254b1e2c932c7ea4689493117e6ce62ac68b" => :x86_64_linux
  end

  depends_on "python@3.8"
  depends_on "rtmpdump"

  resource "PySocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
