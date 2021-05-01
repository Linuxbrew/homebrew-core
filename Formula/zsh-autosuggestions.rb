class ZshAutosuggestions < Formula
  desc "Fish-like fast/unobtrusive autosuggestions for zsh"
  homepage "https://github.com/zsh-users/zsh-autosuggestions"
  url "https://github.com/zsh-users/zsh-autosuggestions/archive/v0.6.4.tar.gz"
  sha256 "0b6e251ced5fd7b5b78ea01f798ecc1b46169743a717567f0ec0a21198a372e8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c606901742fdb8b6124897a896573484f28acb8cc3ab2e440bccfed3e305b9ab"
  end

  uses_from_macos "zsh" => :test

  def install
    pkgshare.install "zsh-autosuggestions.zsh"
  end

  def caveats
    <<~EOS
      To activate the autosuggestions, add the following at the end of your .zshrc:

        source #{HOMEBREW_PREFIX}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

      You will also need to force reload of your .zshrc:

        source ~/.zshrc
    EOS
  end

  test do
    assert_match "history",
      shell_output("zsh -c '. #{pkgshare}/zsh-autosuggestions.zsh && echo $ZSH_AUTOSUGGEST_STRATEGY'")
  end
end
