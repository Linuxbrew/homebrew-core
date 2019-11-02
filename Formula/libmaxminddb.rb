# libmaxminddb: Build a bottle for Linux
class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.4.1/libmaxminddb-1.4.1.tar.gz"
  sha256 "f79327176eca974d0d552ef54d5374717620d8e6aebd7cce316f00f11c303301"

  bottle do
    cellar :any
    sha256 "83d315f644e070379a6abe78b1a99b5506443c16ad7be27ffb968928786626d4" => :catalina
    sha256 "c14b830fdac131232a41abc5e8893738f797d245d33f1131c5a572283ec8745f" => :mojave
    sha256 "c6bb7bb5640648252c3928dbfe4dbfb260970d2b4eff78493374a39de5dc1e52" => :high_sierra
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
