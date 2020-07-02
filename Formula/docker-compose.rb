class DockerCompose < Formula
  include Language::Python::Virtualenv

  desc "Isolated development environments using Docker"
  homepage "https://docs.docker.com/compose/"
  url "https://github.com/docker/compose/archive/1.26.1.tar.gz"
  sha256 "90d274fbe25e95831edb3642491b6dda731492e440155494e0d7361fb7847aa4"
  head "https://github.com/docker/compose.git"

  bottle do
    cellar :any
    sha256 "2fad16dc653ab154af4ab9107bd8222df6370b3fe5ffa64ae31a5b6abb47cefa" => :catalina
    sha256 "bddf16f5594ee5172d3a1afe22ef4d372fb4dc0d7f3fc8112bcaff041015cbec" => :mojave
    sha256 "5a69754a7f778e02ea6b7a4ca6ee0fa97682f2b019e80e43833faba4654bfd13" => :high_sierra
    sha256 "2ddbae1b152bb31875f7c0f31b5964c4d297bd399c91edb9755e82640314e15a" => :x86_64_linux
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
