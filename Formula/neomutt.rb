class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200501.tar.gz"
  sha256 "9d0a0da14448ebb60f2585532fc4cd903c10146903c8639cd0a3d51fe620430f"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    sha256 "b1ab67642b337755ddc385138e5cebc88c77e6528c983a405d7932b24adf7bec" => :catalina
    sha256 "fd92b45fd596a0fd5d837ddde0e23e3e3ba4bf72b9cd6a7b52e613ec6fc6b05d" => :mojave
    sha256 "7708118157d68252accc3c541f81d7e8584ad7b087dd48560d9a394e84f5a61f" => :high_sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"
  unless OS.mac?
    depends_on "krb5"
    depends_on "libsasl2"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--with-gpgme=#{Formula["gpgme"].opt_prefix}",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-ui=ncurses",
                          "--lua",
                          "--with-lua=#{Formula["lua"].prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
