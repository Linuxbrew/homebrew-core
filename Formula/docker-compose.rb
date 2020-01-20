# docker-compose: Build a bottle for Linux
class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/v1.25.2.tar.gz"
  sha256 "c74550785929b319e8ec2771442041b4f77aad7eb54437c10d9f43b92d619f23"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "16c4d12084700eb183a7926d9add0e2a767fd0d3768fc459faccd1da743fea56" => :catalina
    sha256 "246ebf6eaeec12cfaacb81ccce139c4a212e3388eab9aef6c6947b1228ecd748" => :mojave
    sha256 "9dc3e4301c770c74065dadc5fe0e45e4b0eb005c83f8928f59e79f0cb4ef8ff6" => :high_sierra
  end

  depends_on "libyaml"
  depends_on "python@3.8"
  uses_from_macos "libffi"

  def install
    ENV.prepend "CPPFLAGS", "-I#{Formula["libffi"].lib}/libffi-#{Formula["libffi"].version}/include" unless OS.mac?

    system "./script/build/write-git-sha" if build.head?
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "docker-compose"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/docker-compose"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    system bin/"docker-compose", "--help"
  end
end
