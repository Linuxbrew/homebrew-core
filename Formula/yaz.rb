class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.30.3.tar.gz"
  sha256 "f0497fd8420574efab4e5738ea3b70787a6e8042f585156baa30bdc1911ba552"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url "http://ftp.indexdata.dk/pub/yaz/"
    regex(/href=.*?yaz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0f8e1625ff8a952570759b4ae0252c979458212c0ef7a66addbc3444e18ac2cb"
    sha256 cellar: :any,                 big_sur:       "14ac635a852f4a987485398ecdd617de5c4c5855b2c6a7759d266f93ac50424a"
    sha256 cellar: :any,                 catalina:      "d8e464bd3b31a9adfc2d4288477746cc8f548270dce632bdcf7d69fd0cb7603a"
    sha256 cellar: :any,                 mojave:        "d5df6093f4f85f9e13c13c245fc9387e2f9b1fb50fd5096bc894814e8bc0727c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c60aec2fc046658d1db77adc82bbc45fc85e9c2b2b45c16140dd8a2dd7ee22e"
  end

  head do
    url "https://github.com/indexdata/yaz.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c"

  uses_from_macos "libxml2"

  def install
    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make", "install"
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath/"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = shell_output("#{bin}/yaz-iconv -f marc8 -t utf8 #{marc8file}")
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support by running yaz-icu with the example icu_chain
    # from its man page.
    configfile = testpath/"icu-chain.xml"
    configfile.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <icu_chain locale="en">
        <transform rule="[:Control:] Any-Remove"/>
        <tokenize rule="w"/>
        <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
        <transliterate rule="xy > z;"/>
        <display/>
        <casemap rule="l"/>
      </icu_chain>
    EOS

    inputfile = testpath/"icu-test.txt"
    inputfile.write "yaz-ICU	xy!"

    expectedresult = <<~EOS
      1 1 'yaz' 'yaz'
      2 1 '' ''
      3 1 'icuz' 'ICUz'
      4 1 '' ''
    EOS

    result = shell_output("#{bin}/yaz-icu -c #{configfile} #{inputfile}")
    assert_equal expectedresult, result
  end
end
