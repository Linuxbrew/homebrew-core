class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "http://a11y.org"
  url "https://download.gnome.org/sources/at-spi2-core/2.24/at-spi2-core-2.24.1.tar.xz"
  sha256 "1e90d064b937aacfe79a96232ac7e63d28d716e85bd9ff4333f865305a959b5b"

  bottle do
    sha256 "f112039fca4287e3678a82b038b745aee7c1257a5ab5b2e894bb2d5e9d52534e" => :sierra
    sha256 "86d0be669c204a901e67e9e4561dc154c1ce6674328bbc69000da3b5e1606ccf" => :el_capitan
    sha256 "3e50963adf7da7375b20c278942dd2fa1ebd762224a05a503c94d4027bcb2eb0" => :yosemite
    sha256 "0076f89894bfcba22b43e6e20d7ee7503dfb4502ba1ad621f4c9462a0e7be2f0" => :x86_64_linux # glibc 2.19
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "dbus"
  depends_on :x11
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make", "install"
  end
end
