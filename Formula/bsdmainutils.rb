class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.10.tar.gz"
  sha256 "765531369797bb3850a7db57e0d14c8a8d2387e0adfabb6a4cd752304afd2eff"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "6a86b57b37b08fb3a3797a6e3eef2a9f444fb6748fbffb051d5a501a343a1705" => :x86_64_linux
  end

  depends_on "homebrew/dupes/ncurses" unless OS.mac?
  depends_on "libbsd" unless OS.mac?

  def install
    File.open("debian/patches/series").each do |patch|
      system "patch -p1 <debian/patches/#{patch}"
    end
    inreplace "Makefile", "/usr/", "#{prefix}/"
    inreplace "config.mk", "/usr/", "#{prefix}/"
    inreplace "config.mk", " -o root -g root", ""
    inreplace "usr.bin/write/Makefile", "chown root:tty $(bindir)/$(PROG)", ""
    system "make", "install"
  end

  test do
    system "#{bin}/cal"
  end
end
