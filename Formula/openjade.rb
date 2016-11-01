class Openjade < Formula
  desc "Implementation of the DSSSL language"
  homepage "http://openjade.sourceforge.net"
  url "https://downloads.sourceforge.net/openjade/openjade-1.3.2.tar.gz"
  sha256 "1d2d7996cc94f9b87d0c51cf0e028070ac177c4123ecbfd7ac1cb8d0b7d322d1"

  depends_on "opensp"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--enable-spincludedir=#{Formula["opensp"].include}/OpenSP",
      "--enable-splibdir=#{Formula["opensp"].lib}",
      "--enable-http",
      "--enable-default-catalog=#{etc}/sgml/catalog"
    system "make"
    system "make", "install"
    bin.install_symlink bin/"openjade" => "jade"
  end

  test do
    system "#{bin}/jade", "--version"
    assert_match "Usage", shell_output("#{bin}/jade --version")
  end
end
