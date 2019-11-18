class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.7.tar.gz"
  sha256 "fd45480cef0559b3eab965ea3ad4fe2d7a8f27db32c851a032ee0b487c378329"
  # tag "linux"

  bottle do
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
  depends_on "xmltoman" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libdaemon"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5"

    system "./bootstrap.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{prefix}",
                             "--sysconfdir=#{prefix}/etc",
                             "--localstatedir=#{prefix}/var",
                             "--disable-mono",
                             "--disable-monodoc",
                             "--disable-python",
                             "--disable-qt3",
                             "--disable-qt4",
                             "--disable-gtk",
                             "--disable-gtk3",
                             "--with-distro=none",
                             "--with-systemdsystemunitdir=no"
    system "make", "install"
  end

  test do
    assert_match "avahi-browse #{version}", shell_output("#{bin}/avahi-browse --version").chomp
  end
end
