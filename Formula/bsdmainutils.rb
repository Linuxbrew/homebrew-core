class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.12+nmu1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.12+nmu1.tar.gz"
  version "9.0.12+nmu1"
  sha256 "46ae19dcd28b2879379d70d149ea4fbe79b29d6c48e9ba4b576c5b38252043e8"
  # tag "linuxbrew"

  bottle do
    sha256 "f8682d65558e06d54bb1a1853e8000aa9506c6845d8caa1754179dbac0486386" => :x86_64_linux # glibc 2.19
  end

  unless OS.mac?
    depends_on "ncurses"
    depends_on "libbsd"
  end

  def install
    File.open("debian/patches/series") do |file|
      file.each { |patch| system "patch -p1 <debian/patches/#{patch}" }
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
