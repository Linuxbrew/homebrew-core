class Softhsm < Formula
  desc "Cryptographic store accessible through a PKCS#11 interface"
  homepage "https://www.opendnssec.org/softhsm/"
  url "https://dist.opendnssec.org/source/softhsm-2.6.0.tar.gz"
  sha256 "19c2500f22c547b69d314fda55a91c40b0d2a9c269496a5da5d32ae1b835d6d1"

  bottle do
    sha256 "6191b8427b45b0d497df2442326a1ef771d780528a1af630283921314631d7f5" => :catalina
    sha256 "b3df4c2a1b79e2f741a364be111653d49cf096335ce81597a1fed376368c19ee" => :mojave
    sha256 "a6b0ca9197123c0e13bbcf8e29e42a2b8bb6b3288b8b953be244ce9d3d0cb920" => :high_sierra
  end

  depends_on "openssl@1.1"

  unless OS.mac?
    fails_with :gcc => "5"
    fails_with :gcc => "6"
    depends_on "gcc@7"
  end

  # Fix macOS compile.
  # Remove with the next release.
  patch do
    url "https://github.com/opendnssec/SoftHSMv2/commit/0601e4014dc2c1296b25d4868f8d7a50c0e31e75.patch?full_index=1"
    sha256 "e860d142e8e6aa757b381789d8aad0bae09f93caed3ae37c3fc67dcefea18099"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/softhsm",
                          "--localstatedir=#{var}",
                          "--with-crypto-backend=openssl",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--disable-gost"
    system "make", "install"
  end

  def post_install
    (var/"lib/softhsm/tokens").mkpath
  end

  test do
    (testpath/"softhsm2.conf").write("directories.tokendir = #{testpath}")
    ENV["SOFTHSM2_CONF"] = "#{testpath}/softhsm2.conf"
    system "#{bin}/softhsm2-util", "--init-token", "--slot", "0",
                                   "--label", "testing", "--so-pin", "1234",
                                   "--pin", "1234"
    system "#{bin}/softhsm2-util", "--show-slots"
  end
end
