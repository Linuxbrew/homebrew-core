class Opensp < Formula
  desc "OpenJade group's SGML parsing tools"
  homepage "http://openjade.sourceforge.net/doc/"
  url "http://downloads.sourceforge.net/openjade/OpenSP-1.5.2.tar.gz"
  sha256 "57f4898498a368918b0d49c826aa434bb5b703d2c3b169beb348016ab25617ce"

  depends_on "xmlto"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false" #xxx fixme
  end
end
