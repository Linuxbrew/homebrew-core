class Bro < Formula
  desc "Network security monitor"
  homepage "https://www.bro.org"
  url "https://www.bro.org/downloads/bro-2.6.4.tar.gz"
  sha256 "a47a9cdcef0ea14d5f70c390ab266f0333063ff96f3869a5f1609581a1d1ceb7"
  revision 1
  head "https://github.com/bro/bro.git"

  bottle do
    sha256 "419e0702059d7ee0170735650a189d6a556f7fe9c3666b2f49bd2045412679dd" => :catalina
    sha256 "a39e2533cbb05e69cf93e984a1a7c17ba009590c57d9251fe07a21a6c435ce9e" => :mojave
    sha256 "8e477f1ed235aee0449950b6492d103fe722cb48f4c66fe394dc129b88150ef8" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "openssl@1.1"
  uses_from_macos "flex"
  uses_from_macos "libpcap"
  uses_from_macos "python@2"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-caf=#{Formula["caf"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-broker-tests",
                          "--localstatedir=#{var}",
                          "--conf-files-dir=#{etc}"
    system "make", "install"
  end

  test do
    system "#{bin}/bro", "--version"
  end
end
