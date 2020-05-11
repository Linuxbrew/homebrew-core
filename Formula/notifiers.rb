class Notifiers < Formula
  include Language::Python::Virtualenv

  desc "The easy way to send notifications"
  homepage "https://pypi.org/project/notifiers/"
  url "https://files.pythonhosted.org/packages/4f/36/4c300f55949b9be84284d51253ae48d564dc2c4f2bffb94f26c8c1485f07/notifiers-1.2.1.tar.gz"
  sha256 "34625af405f4aa19293eaaefe145ccc92c6018ae9798f53a03a7fcc996e541aa"
  revision OS.mac? ? 1 : 2

  bottle do
    cellar :any_skip_relocation
    sha256 "15b3d5569555bfe205b9a1082d593b45bf63d96b3cdedf1c48e48237e5e3b2fa" => :catalina
    sha256 "bfa56f4cd556c997cd098de3406c62c11eef9c5d52a2e00d883ff6ab2c88eaad" => :mojave
    sha256 "74179f3313ffe62642eabba8f25a660bdf9c75d19aaab8a277fb96d51394979c" => :high_sierra
    sha256 "5471c5c169c7c66160cb271a2ea08c6b7a66d659b178814b116ae40497b6e960" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "notifiers"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "notifiers", shell_output("#{bin}/notifiers --help")
  end
end
