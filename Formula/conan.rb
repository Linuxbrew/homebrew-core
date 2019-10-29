# conan: Build a bottle for Linuxbrew
class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.19.3.tar.gz"
  sha256 "a60de842d7767b99e221025cff4b416c0ee19f45f1e1b8b38c2b045636aba192"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "1024b329b61a31480d4ab6964204013a670483fe74cc0889186f80e60cb41508" => :catalina
    sha256 "d7b064e3ae41808edf7d95c56ba4a41e02f7728b28a7c53cf31bab20d8ae6908" => :mojave
    sha256 "f46667763606778c4521c6f0fa37d1cb02eeadaf05964ce7c5f9650fda146103" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", "PyYAML==3.13", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
