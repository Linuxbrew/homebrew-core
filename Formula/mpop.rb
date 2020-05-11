class Mpop < Formula
  desc "POP3 client"
  homepage "https://marlam.de/mpop/"
  url "https://marlam.de/mpop/releases/mpop-1.4.9.tar.xz"
  sha256 "b820c4ad72dcf6dfa94d2f45042a713777b3b73895e737224ffe464a9aaf3642"

  bottle do
    sha256 "916386cfdb7771289edfb648b75372b29585a56dda714f302b0fc4c9076e1e47" => :catalina
    sha256 "d0fd649fbc08b89460bcb6c98dfa1d8e52efc158deaa49a50d56562f06a0bc0d" => :mojave
    sha256 "6cf5cbc88fdd14a03d7ae3aa19c4d3b493c6c4ebf10ab447c559630f5b0cdcf5" => :high_sierra
    sha256 "72c59269390db2c32dc137400ea03d02e38e3ebe239e89699be3c73f363fc17c" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
