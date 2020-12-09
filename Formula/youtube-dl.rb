class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/f0/a0/7fa01ee4be8d713feaf8647747a2b9d6788285aabcd7ae0e71a494a1ade3/youtube_dl-2020.12.5.tar.gz"
  sha256 "c73c79ccaabb7eabc223b36889ad9d3fbe04433d933312e8752d6a2c2bdc028d"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb888df4b077852b52ee20f24b357a53765c63ac2b158850885b4f9a6413b74d" => :big_sur
    sha256 "75b164d8356512900032fc1fe1a862cfa81503f09c73ca9a06dd06584ccd40c3" => :catalina
    sha256 "aede38d0e537d566746d4457118f8297dbc2dd1d5b989b5c578581fa801db950" => :mojave
    sha256 "bd07bac8a82b8a43b5c8afc1486a053b8f9133b92145297b870ab5fba2b80394" => :x86_64_linux
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/youtube-dl.1" => "youtube-dl.1"
    bash_completion.install libexec/"etc/bash_completion.d/youtube-dl.bash-completion"
    fish_completion.install libexec/"etc/fish/completions/youtube-dl.fish"
  end

  test do
    # commit history of homebrew-core repo
    system "#{bin}/youtube-dl", "--simulate", "https://www.youtube.com/watch?v=pOtd1cbOP7k"
    # homebrew playlist
    system "#{bin}/youtube-dl", "--simulate", "--yes-playlist", "https://www.youtube.com/watch?v=pOtd1cbOP7k&list=PLMsZ739TZDoLj9u_nob8jBKSC-mZb0Nhj"
  end
end
