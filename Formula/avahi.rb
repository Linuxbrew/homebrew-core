class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "https://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.8.tar.gz"
  sha256 "c15e750ef7c6df595fb5f2ce10cac0fee2353649600e6919ad08ae8871e4945f"

  bottle do
    rebuild 1
    sha256 x86_64_linux: "f917789b377a8aba9b81a612053d46716d07012c6f98e908e03b8eb580ee0146"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "xmltoman" => :build
  depends_on "dbus"
  depends_on "glib"
  depends_on "libdaemon"
  depends_on :linux

  def install
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
