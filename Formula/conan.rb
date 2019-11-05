# conan: Build a bottle for Linux
class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.20.2.tar.gz"
  sha256 "e54a1f670116e47f2a1fb95e17a1211439868661a0f8afc4ca3616e075e76070"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "b25179dde8a81879471448648412a08ee86e55d778b1eb6f5c9a9c255be2904e" => :catalina
    sha256 "9d8b1196211b432a4b8fb509c1acca28e78b686a05b047b28ea6d076cc3f3ed5" => :mojave
    sha256 "d806bce37430b761e4db3910857aa18be063d92f9b702e54f71954548407c79e" => :high_sierra
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
