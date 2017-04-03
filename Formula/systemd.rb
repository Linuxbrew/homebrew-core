class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v232.tar.gz"
  sha256 "1172c7c7d5d72fbded53186e7599d5272231f04cc8b72f9a0fb2c5c20dfc4880"
  head "https://github.com/systemd/systemd.git"
  # tag "linuxbrew"

  bottle do
    sha256 "b24ff69678f718005768a023d1c264c2486cc69027be407107341c5f648d0fcd" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "homebrew/dupes/gperf" => :build
  depends_on "homebrew/dupes/m4" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "libxslt" => :build # for xsltproc
  depends_on "pkg-config" => :build
  depends_on "libcap"
  depends_on "util-linux" # for libmount
  depends_on "XML::Parser" => :perl

  # src/core/dbus.c:1022:5: internal compiler error: Segmentation fault
  fails_with :gcc => "4.8"
  fails_with :c_compiler if OS.linux? # Do not use /usr/bin/cc

  env :super

  stable do
    # Fix error: conflicting types for 'lookup_arphrd'
    patch do
      url "https://github.com/systemd/systemd-stable/commit/79a5d862a7abe903f456a75d6d1ca3c11adfa379.patch"
      sha256 "cdb6e9c7858fe24f402ea4371ed75d889f3359c741cceb7d087241706e5b85d4"
    end
  end

  def install
    # Fix error: unsupported reloc 42
    inreplace "configure.ac", "-Wl,-fuse-ld=gold", ""

    # Fix compilation error: file ./man/custom-html.xsl line 24 element import
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}",
      "--sysconfdir=#{etc}",
      "--with-rootprefix=#{prefix}",
      "--with-sysvinit-path=#{etc}/init.d",
      "--with-sysvrcnd-path=#{etc}/rc.d"
    system "make", "install"
  end

  test do
    system "#{bin}/systemd-path"
  end
end
