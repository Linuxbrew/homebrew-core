class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.8.tar.gz"
  sha256 "c15e750ef7c6df595fb5f2ce10cac0fee2353649600e6919ad08ae8871e4945f"

  bottle do
    sha256 x86_64_linux: "9d76bcfece943950baceee7f9cd18de2302190228493dc8b832fd00f4e0afe6d"
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
  depends_on :linux

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
                             "--disable-qt4",
                             "--disable-qt5",
                             "--disable-gtk",
                             "--disable-gtk3",
                             "--disable-libevent",
                             "--with-distro=none",
                             "--with-systemdsystemunitdir=no"
    system "make", "install"
  end

  test do
    assert_match "avahi-browse #{version}", shell_output("#{bin}/avahi-browse --version").chomp
  end
end
