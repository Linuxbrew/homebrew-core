class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://github.com/systemd/systemd/archive/v234.tar.gz"
  sha256 "da3e69d10aa1c983d33833372ad4929037b411ac421fb085c8cee79ae1d80b6a"
  head "https://github.com/systemd/systemd.git"
  # tag "linuxbrew"

  bottle do
    sha256 "b24ff69678f718005768a023d1c264c2486cc69027be407107341c5f648d0fcd" => :x86_64_linux # glibc 2.19
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on "libxslt" => :build # for xsltproc
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
  depends_on "libcap"
  depends_on "util-linux" # for libmount

  # src/core/dbus.c:1022:5: internal compiler error: Segmentation fault
  fails_with :gcc => "4.8"

  unless OS.mac?
    depends_on "expat"

    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    unless OS.mac?
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
          system "make", "install"
        end
      end
    end

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
      "--sysconfdir=#{prefix}/etc",
      "--with-rootprefix=#{prefix}",
      "--with-sysvinit-path=#{prefix}/etc/init.d",
      "--with-sysvrcnd-path=#{prefix}/etc/rc.d"
    system "make", "install"
  end

  test do
    system "#{bin}/systemd-path"
  end
end
