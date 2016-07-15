class Cups < Formula
  desc "Common UNIX printing system"
  homepage "https://www.cups.org/"
  url "https://github.com/apple/cups/releases/download/release-2.1.4/cups-2.1.4-source.tar.gz"
  sha256 "4b14fd833180ac529ebebea766a09094c2568bf8426e219cb3a1715304ef728d"

  option "with-test"

  depends_on "zlib" => :recommended
  depends_on "openssl" => :recommended
  depends_on "hicolor-icon-theme"
  depends_on "homebrew/dupes/krb5" unless OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --datarootdir=#{share}
      --with-icondir=#{share}/icons
      --disable-dbus
      --disable-debug
    ]
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "false"
  end
end
