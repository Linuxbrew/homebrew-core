class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.25.1.tar.gz"
  sha256 "3aa043a46c695c3e81f969111930226561a938fc53f24cf1b9cc30e0919114ef"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "1fa9c4d596028d7a87025dea49a5a593a13ea22fe6b6833b616f2d570615b4e1" => :catalina
    sha256 "f86550987e89fa6b791e271c164d06a5b8062b18de9af7f56cc35742140d77bd" => :mojave
    sha256 "027937d09944137ed05924b9e93504dd1de95f62610f67d2ddd77397c0172033" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system bin/"conan", "install", "zlib/1.2.11@conan/stable", "--build"
    assert_predicate testpath/".conan/data/zlib/1.2.11", :exist?
  end
end
