class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/47/26/ee61a6841bc81e59a0bdb610b75a9266659bda02227894d0cea22a7d9c1c/jc-1.15.3.tar.gz"
  sha256 "239c79b54b059dee73ac7fc23357db20ed5e7d749c95eb5deae749001fbbd3c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2342fa985c24956e55f69cc4f12df7815d6df1537b7fb9c0b41fc7e062871af7"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a2b897f45099917924dfb024887ea2d11748b00f82fb7ded43ce3cb1bd7687c"
    sha256 cellar: :any_skip_relocation, catalina:      "aedb739cf7941e9765ebf84a5f7d088d85e9e3e7efc8b006fefbf2af7cff2cd7"
    sha256 cellar: :any_skip_relocation, mojave:        "09175a5efe81ba502a32c6b05f7bc8750fa6c92be179d0048d23136b3d799270"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1a5c8614e16870e0eb5210e568bff82528ce46c3ef0dc60a360f1805ce87788"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
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
