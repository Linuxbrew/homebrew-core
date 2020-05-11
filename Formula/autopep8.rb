class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/41/5b/3bd26811d311ae0b819487a3d97557ca0181de1c49a8dca1ab2c8dfac4f6/autopep8-1.5.2.tar.gz"
  sha256 "152fd8fe47d02082be86e05001ec23d6f420086db56b17fc883f3f965fb34954"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "ff9215148302566d91dfa99d47cc71e3375be09bacf62cd79391421e85cab851" => :catalina
    sha256 "ef8ac804ac624e53ab3dd33326cc193889ddfee64b57d2c4dd37c32d02e0227a" => :mojave
    sha256 "8937748c1dbb5af4864b245d152a767fec8300430bd8f42351854eecede4c867" => :high_sierra
    sha256 "7ccab5189fc751fc05e6619361e649a0e94be72d6d5a35e1da1d84459a9c2ea4" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    output = shell_output("echo \"x='homebrew'\" | #{bin}/autopep8 -")
    assert_equal "x = 'homebrew'", output.strip
  end
end
