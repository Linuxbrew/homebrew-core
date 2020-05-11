require "language/haskell"

class Hlint < Formula
  include Language::Haskell::Cabal

  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.1/hlint-3.1.tar.gz"
  sha256 "5021a77468ea8745a5316265db08eebda7fe9b5e5f3a5500e753aad61c5b27b0"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    sha256 "f8302a2636717e98c9d84eef9f03f678db4cd78ab4c69ae2ed234a4e4c6a1637" => :catalina
    sha256 "99be3337d8695b45b40353c9c1d8657167cb7132a1077a71603f3b6b480e5d4e" => :mojave
    sha256 "aa168f2f438251a5a359f0fa4b29d584bd1273b7758c3a083daaf16f2a247a8d" => :high_sierra
    sha256 "ad5fa650834624c214e20301d0fd17566cfa193cf24852a5910cd10909884549" => :x86_64_linux
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build

  uses_from_macos "ncurses"

  def install
    install_cabal_package :using => ["alex", "happy"]
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "Redundant do", shell_output("#{bin}/hlint test.hs", 1)
  end
end
