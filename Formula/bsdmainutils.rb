class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.6.tar.gz"
  sha256 "48868ac99c8dd92a69bb430e6bdf865602522ad3a2f5a0dd9cae77b46fc93b57"
  # tag "linuxbrew"

  depends_on "homebrew/dupes/ncurses" unless OS.mac?

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
