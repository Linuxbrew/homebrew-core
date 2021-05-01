class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/ef/62/1e17d116cf279922ac48cd0312af856ae1850803622f934619d509b1d18f/translate-toolkit-3.3.5.tar.gz"
  sha256 "e58e1004f1dc82b609a2ba0590d4054456e5b9950a164ba184a1157ea1dc8e92"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "51c6625787fdec3d6f9622f8a41f3813b1daa1c80d84fe0d57e34854f623ee4f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e3c06548fb4e216d6f3d0e1d709b29857da7c87dd195f30dcf2ef3f413abae8b"
    sha256 cellar: :any_skip_relocation, catalina:      "214660f74f4c65b5ef43c76e0d08c636cccf5e4583012dfc3ae112e87444e553"
    sha256 cellar: :any_skip_relocation, mojave:        "131ea7bda6b43797c7f9a734fc89279123d26f143301dd9afcb81560d05b122b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13bd4fefdadb038c57cdf87e25bd0af05150100881d9becc63dce973e4cb253"
  end

  depends_on "python@3.9"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
