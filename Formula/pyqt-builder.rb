class PyqtBuilder < Formula
  include Language::Python::Virtualenv

  desc "Tool to build PyQt"
  homepage "https://www.riverbankcomputing.com/software/pyqt-builder/intro"
  url "https://files.pythonhosted.org/packages/27/c2/9fcaf0f4eb96dc06dc38ca66e4f1bb890b9852f62b93069b81646f7bff65/PyQt-builder-1.10.3.tar.gz"
  sha256 "6ade47445b7d8c08eb96e91ebda5f8b3494b3e7a9da2be343b9d0704419cb5c7"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]
  head "https://www.riverbankcomputing.com/hg/PyQt-builder", using: :hg

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a69ac546cf18592b6d0ac03cf09d9f88accffed55a2a68858a149558bee69f04" # linuxbrew-core
  end

  depends_on "python@3.9"
  depends_on "sip"

  def install
    system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system bin/"pyqt-bundle", "-V"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import pyqtbuild"
  end
end
