class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://www.freedesktop.org/software/systemd/systemd-221.tar.xz"
  sha256 "085e088650afbfc688ccb13459aedb1fbc7c8810358605b076301f472d51cc4f"
  # tag "linuxbrew"

  bottle do
    sha256 "b24ff69678f718005768a023d1c264c2486cc69027be407107341c5f648d0fcd" => :x86_64_linux
  end

  depends_on "homebrew/dupes/gperf" => :build
  depends_on "homebrew/dupes/m4" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libcap"
  depends_on "pkg-config" => :build
  depends_on "util-linux" # for libmount
  depends_on "coreutils" => :build
  depends_on "XML::Parser" => :perl
  depends_on "expat" => :build unless OS.mac?

  resource "xml::parser" do
    url "http://search.cpan.org/CPAN/authors/id/M/MS/MSERGEANT/XML-Parser-2.36.tar.gz"
    sha256 "9fd529867402456bd826fe0e5588d35b3a2e27e586a2fd838d1352b71c2ed73f"
  end

  def install
    if ENV["TRAVIS"]
      resource("xml::parser").stage do
        system "perl", "Makefile.PL", "PREFIX=/home/linuxbrew/perl5"
        system "make"
        system "make", "install"
      end
    end

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-rootprefix=#{prefix}",
      "--with-sysvinit-path=#{etc}/init.d",
      "--with-sysvrcnd-path=#{etc}/rc.d"
    system "make", "install"
  end

  test do
    system "#{bin}/systemd-path"
  end
end
