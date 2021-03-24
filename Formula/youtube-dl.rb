class YoutubeDl < Formula
  include Language::Python::Virtualenv

  desc "Download YouTube videos from the command-line"
  homepage "https://youtube-dl.org/"
  url "https://files.pythonhosted.org/packages/21/b4/b910f76850b9e5d9022ff80e55e1fee793b20c3cbbbe0310c9ea67ac059b/youtube_dl-2021.3.25.tar.gz"
  sha256 "375c19339fd6b64cb09f174c4681159a88352c5559c3453dc082020adea2980e"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60f2787002b67afab32ce6a9a21cbb2f6c1d3005e50d425e834bdbbfdfb80114"
    sha256 cellar: :any_skip_relocation, big_sur:       "197c090e774b444d96fbdc85b08a332954e7d4909a29b9fad0c172aaff1da490"
    sha256 cellar: :any_skip_relocation, catalina:      "781b75f7dc267184d859c75664287875b57f895e8155544a3e635857a4f950f2"
    sha256 cellar: :any_skip_relocation, mojave:        "90ba27f59fa561147f212ed52ed273a891ef8011f3d73bfaaa81cf9cda27ef0f"
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
