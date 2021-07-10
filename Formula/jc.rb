class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/3c/14/41440102691264714148c55c29e7220cbd7ee11c2c06617693377ccabb94/jc-1.15.6.tar.gz"
  sha256 "249ea24e16e324eab35caae2b9ddd31eaf3e0820ef46d587a4fcfd30a9532c17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc48dbd4bc4971371b98a38ac00184bf71c6bfdd3255ff9481b3093e1dc623d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "b63408852e77d527bea6ca4fc301f08056bd82439770ccbceafd9449a99f2ca7"
    sha256 cellar: :any_skip_relocation, catalina:      "3eab5b0b5a38b24da1ea61343b95d1fc5ee721df216421769447ac727ec057c3"
    sha256 cellar: :any_skip_relocation, mojave:        "997c1be1d30d1aa5bfcbbe89e8c5643250adcbb55d917b3f7dce7f2f15b1b02d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2f6141079f6d74f8e4a79a49547f16b9b4aef635911e4abfb4747d9b5834bea" # linuxbrew-core
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/83/59/4f576abb336d30b3d47061717224be714a9dc39c774061c34cb41c1795cf/ruamel.yaml-0.17.10.tar.gz"
    sha256 "106bc8d6dc6a0ff7c9196a47570432036f41d556b779c6b4e618085f57e39e67"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/b7/81/c04fb9be62657d4dce8aa2d99fde258a3af1cd77ec72af525593e9560127/ruamel.yaml.clib-0.2.4.tar.gz"
    sha256 "f997f13fd94e37e8b7d7dbe759088bb428adc6570da06b64a913d932d891ac8d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jc/man/jc.1.gz"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
