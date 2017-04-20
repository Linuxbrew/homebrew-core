class DocbookUtils < Formula
  desc "Convert DocBook files to other formats (HTML, RTF, PS, man, PDF)"
  homepage "https://www.sourceware.org/docbook-tools/"
  url "ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/docbook-utils-0.6.14.tar.gz"
  sha256 "48faab8ee8a7605c9342fb7b906e0815e3cee84a489182af38e8f7c0df2e92e9"

  depends_on "openjade"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/docbook2html", "--version"
    assert_match "Usage", shell_output("#{bin}/docbook2html --version")
  end
end
