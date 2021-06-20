class Enchant < Formula
  desc "Spellchecker wrapping library"
  homepage "https://abiword.github.io/enchant/"
  url "https://github.com/AbiWord/enchant/releases/download/v2.3.0/enchant-2.3.0.tar.gz"
  sha256 "df68063b6c13b245fa7246b0e098a03e74f7a91c6d8947bc5c4f42ce55e2e41d"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 arm64_big_sur: "b5a33d94c354cef749a27ba33708d75df4e5155b477bde01692a75f89bc18120"
    sha256 big_sur:       "bf3bfe2bd2d71bf787c84db5ab1141961b66a6cfc98438555da70162fb0a1f9c"
    sha256 catalina:      "446db311b0f9926c31b38c7663f4598940ce87aa5871416b3aa229d4b0294dcd"
    sha256 mojave:        "06c3c748e6c955c17d8611c7067a40df9547ea9fc3e70a53171d8dd0d874a488"
  end

  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "glib"

  on_linux do
    depends_on "gcc"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-relocatable",
                          "--with-aspell-dir=#{Formula["aspell"].share}"

    system "make", "install"
    ln_s "enchant-2.pc", lib/"pkgconfig/enchant.pc"
  end

  test do
    text = "Teh quikc brwon fox iumpz ovr teh lAzy d0g"
    enchant_result = text.sub("fox ", "").split.join("\n")
    file = "test.txt"
    (testpath/file).write text
    assert_equal enchant_result, shell_output("#{bin}/enchant-2 -l #{file}").chomp
  end
end
