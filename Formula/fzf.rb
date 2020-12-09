class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.24.4.tar.gz"
  sha256 "0d9d3ed3cefee86accc2634fc98211af1d571845d912256c33ca0c8b2963d8bd"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2dbde85df14e4381a1ca63257a78cd3cbc60bd7c2f44910a738ad106d6517cf" => :big_sur
    sha256 "20bae77a697278028e2a363c0286ac18d4e9f140cabf2b08ec4e3409dcde56d4" => :catalina
    sha256 "5af94f0a2a6f33b165b509a9f02cd7862fcd209c066b1e888c012e18ffb65e43" => :mojave
    sha256 "03a9596d7a53d9b8e16ff9f3e23a213aedaae7e5d6f5319e2a88ff601b5acb57" => :x86_64_linux
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    system "go", "build", "-o", bin/"fzf", "-ldflags", "-X main.version=#{version} -X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
