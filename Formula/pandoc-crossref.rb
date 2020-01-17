# pandoc-crossref: Build a bottle for Linux
require "language/haskell"

class PandocCrossref < Formula
  include Language::Haskell::Cabal

  desc "Pandoc filter for numbering and cross-referencing"
  homepage "https://github.com/lierdakil/pandoc-crossref"
  url "https://hackage.haskell.org/package/pandoc-crossref-0.3.5.0/pandoc-crossref-0.3.5.0.tar.gz"
  sha256 "646ea9b0d1564f894528036724d7a112d54e6946555602cd15c421b48fc301f4"
  revision 1

  bottle do
    sha256 "3dcc3aa085dfa3534430eb825b7d00fd85e7a4dac128f3199f1b4779330119f6" => :catalina
    sha256 "2ecc6d308b8bde194e0bcb0e902eab2442a954a4956d5f40d83c6c1daa0d14f8" => :mojave
    sha256 "2f160d55d63acc7df1c3009928bfc146f4a43e34461a53db581df94c474932a4" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build
  depends_on "pandoc"
  unless OS.mac?
    depends_on "unzip" => :build
    depends_on "zlib"
  end

  def install
    install_cabal_package
  end

  test do
    (testpath/"hello.md").write <<~EOS
      Demo for pandoc-crossref.
      See equation @eq:eqn1 for cross-referencing.
      Display equations are labelled and numbered

      $$ P_i(x) = \\sum_i a_i x^i $$ {#eq:eqn1}
    EOS
    system Formula["pandoc"].bin/"pandoc", "-F", bin/"pandoc-crossref", "-o", "out.html", "hello.md"
    assert_match "∑", (testpath/"out.html").read
  end
end
