# pandoc: Build a bottle for Linux
require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.8.1/pandoc-2.8.1.tar.gz"
  sha256 "dd10776259926cc3e82eb307eea1cf8e6a4e0578cc8812eb4ee0366b84d2b453"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "56d67a7cfed18613811b8738f1300b558beb8a3caff1eec53043028b8fde1b4d" => :catalina
    sha256 "2c19a32faefbc83d0d1c0133170571b58a3a3884976642ce1dc12a94e5810d15" => :mojave
    sha256 "69a4880c389d4b0862731f312f422b751da851431635203f5b0aa33e38d2f5f5" => :high_sierra
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
