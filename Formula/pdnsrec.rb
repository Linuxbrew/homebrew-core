class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/recursor.html"
  url "https://downloads.powerdns.com/releases/pdns-recursor-4.4.1.tar.bz2"
  sha256 "f97fa34635d42c68acee5d4da9db0e5ff619fd49e62acace7b4bdb7ee3675698"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "0f080e316dd2d20e656f7ae48dbb881fc9824a5ca35b468dd9fd153c9e2a3c22" => :big_sur
    sha256 "f38be52b2d55015172cc0e89dac5a29eadffdd12e8f7b21c4247050237ffc246" => :catalina
    sha256 "f1e89927a21f517c6e96668149735b838fa1f9e96e36878fbbddc52d61253900" => :mojave
    sha256 "d457c35465a16903cf3e55c8812c24ee62a72e460f128cdef68357cf95bbb1c2" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gcc" if OS.mac? && DevelopmentTools.clang_build_version <= 600
  depends_on "lua"
  depends_on "openssl@1.1"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-libcrypto=#{Formula["openssl@1.1"].opt_prefix}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
