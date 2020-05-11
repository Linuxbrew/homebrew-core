class Conan < Formula
  include Language::Python::Virtualenv

  desc "Distributed, open source, package manager for C/C++"
  homepage "https://github.com/conan-io/conan"
  url "https://github.com/conan-io/conan/archive/1.25.0.tar.gz"
  sha256 "0cd4ea9be6c3882a7d989bccc6b9fcf5d519276670a60d2e2553ebf44ac93406"
  head "https://github.com/conan-io/conan.git"

  bottle do
    cellar :any
    sha256 "a10dedb00c6f87f7f0ab22cc28cf9082644268c4afb9327058393e10ba8f8d6b" => :catalina
    sha256 "a08f8bf12b7e494125dffb8a214c817053eddd3eeab734554020c43eed748039" => :mojave
    sha256 "06b531ada3fd1dcbbc88edf7c72c3b073501898c625225852717c7410c7c53d7" => :high_sierra
    sha256 "3ff8486b971295179c56a8066d8d510f9eefbbd5119ecda46bbfe254d5dc89e1" => :x86_64_linux
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
