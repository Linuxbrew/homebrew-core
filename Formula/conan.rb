# conan: Build a bottle for Linux
class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.20.3.tar.gz"
  sha256 "b33a14169e26130d6298dc8f613670cf2481dd3024879753a7f8ee408094b4bd"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "bd220a91ac73c33f691c2d976b33675fbbc9a5a5c681623b9c02e0d100309e61" => :catalina
    sha256 "b0dbb57a0e0f6bf72a01d757b6cb04f7d0c375ea8fb2fedbc9f7b672d5d6c8d7" => :mojave
    sha256 "459dc547bcb1cb646c9cdffa848349e10db8e90a2e8802318e633f73d344c457" => :high_sierra
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
