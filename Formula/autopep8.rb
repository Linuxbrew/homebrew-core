# autopep8: Build a bottle for Linux
class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/12/55/7b07585ca0c30e5b216e4d627f82f96f1a7e82d2dd727b1f926cb3f3d58b/autopep8-1.5.tar.gz"
  sha256 "0f592a0447acea0c2b0a9602be1e4e3d86db52badd2e3c84f0193bfd89fd3a43"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3aae4544f049fe60fc115c16f5c27cb0ecfbfc3b1874606dfd6959a09552f9b" => :catalina
    sha256 "92c1b4cb88fac852a760e28fea55a3981bcbfb6334782ac2dd1d0f56d739f26a" => :mojave
    sha256 "964cf580cff80b8162ce2c94b51fa4a79b981b6321478c96f22c9a1bdbac46c9" => :high_sierra
    sha256 "05f5577a5006582c0a3085d2e5d9216d0013afd9f4dc1958eccaa90901b38848" => :x86_64_linux
  end

  depends_on "python"

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
