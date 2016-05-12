class Bsdmainutils < Formula
  desc "Collection of utilities from FreeBSD"
  homepage "https://packages.debian.org/sid/bsdmainutils"
  url "http://ftp.debian.org/debian/pool/main/b/bsdmainutils/bsdmainutils_9.0.10.tar.gz"
  sha256 "765531369797bb3850a7db57e0d14c8a8d2387e0adfabb6a4cd752304afd2eff"
  # tag "linuxbrew"

  def install
    # calendar fails to build: undefined reference to `strtonum'
    rm_rf "usr.bin/calendar"

    # Fix error: expected declaration specifiers or ‘...’ before string constant
    inreplace Dir["usr.bin/*/*.c"] - ["usr.bin/ncal/ncal.c", "usr.bin/ul/ul.c"],
      '__FBSDID("$FreeBSD$");', ""
    # Fix error: expected ‘;’, ‘,’ or ‘)’ before ‘__unused’
    inreplace ["usr.bin/hexdump/odsyntax.c", "usr.bin/write/write.c"],
      " __unused", ""

    system "for i in `<debian/patches/series`; do patch -p1 <debian/patches/$i; done"
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
