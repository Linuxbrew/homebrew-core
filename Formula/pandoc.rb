# pandoc: Build a bottle for Linux
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.9.1/pandoc-2.9.1.tar.gz"
  sha256 "0a543566be3468a0283d08cf6f3cda44c70de46b52755d902277273450d78bfb"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "02ea8a0f8e79cbdd081c5464074269b4e3c4b0b7dc15b63a169552591894f1ed" => :catalina
    sha256 "426c54af7e4b1a13011c911a636e990cbf87ef2903b7b64940adba17ac70214b" => :mojave
    sha256 "448ebb5eea5eef2df4cfbb070aeb3c02d0a9567ae15984c0ab89854e65f348aa" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  unless OS.mac?
    depends_on "unzip" => :build # for cabal install
    depends_on "zlib"
  end

  def install
    cabal_sandbox do
      install_cabal_package
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
