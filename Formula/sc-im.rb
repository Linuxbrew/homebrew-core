class ScIm < Formula
  desc "Spreadsheet program for the terminal, using ncurses"
  homepage "https://github.com/andmarti1424/sc-im"
  url "https://github.com/andmarti1424/sc-im/archive/v0.8.0.tar.gz"
  sha256 "ba65b3936a21ae65b19d99a4cfbb69bb57d8b00880f0781fb620e8857bc498db"
  license "BSD-4-Clause"
  head "https://github.com/andmarti1424/sc-im.git", branch: "freeze"

  bottle do
    sha256 arm64_big_sur: "d62fcbf7991ec40f521e475f89352aaa377ebbdd0f855d4873cb05c6dbc7a612"
    sha256 big_sur:       "20aa7d533af3006637e41c0d321fc962a699192cafed8b4412ba5fd636ed87c1"
    sha256 catalina:      "853ebd92243deb555e37b98fe07336182fff4b733981d871a2df45420b6ecece"
    sha256 mojave:        "6527827b290f1a40a154d2fd32a7142720c1413c801b9bb9bc49ddaa845915ed"
  end

  depends_on "ncurses"

  def install
    cd "src" do
      system "make", "prefix=#{prefix}"
      system "make", "prefix=#{prefix}", "install"
    end
  end

  test do
    input = <<~EOS
      let A1=1+1
      getnum A1
    EOS
    output = pipe_output(
      "#{bin}/sc-im --nocurses --quit_afterload 2>/dev/null", input
    )
    assert_equal "2", output.lines.last.chomp
  end
end
