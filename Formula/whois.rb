class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.1.tar.xz"
  sha256 "3ee6591fb14c103791430a8e6eb3d4c38a9f52aad799ea58c94250bd6985ec50"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "ea946cc40b9785347572dda2b7f62c2e26e45e52e3321e3675344bd3cfd13397" => :mojave
    sha256 "0ce754d0d55a28926e7e52d3ed1b68ed6dc4c0cce93c17319471da33e933fcde" => :high_sierra
    sha256 "00f07c1b7d94fddfef15e14c58a8f74b1b2313e4ce8c3864dbe68d6151e4a2fa" => :sierra
    sha256 "5e1e17d2fd391257290850793028d1db4bf15074c8611a1a8a41801c01f6130e" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    system "make", "whois", *(OS.mac? ? "HAVE_ICONV=1" : "HAVE_ICONV=0")
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
  EOS
  end

  test do
    system "#{bin}/whois", "brew.sh" if Pathname.new("/etc/services").readable?
  end
end
