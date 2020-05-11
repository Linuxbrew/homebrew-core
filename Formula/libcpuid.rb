class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.4.1.tar.gz"
  sha256 "263b370d154d55e3b7246e069600b045d27c512456f051e9ce3d999318b58b61"
  head "https://github.com/anrieff/libcpuid.git"

  bottle do
    cellar :any
    sha256 "c0f18e27d65429a6c3056a703e6d3566c1faf83414940b01117710ce9405d702" => :catalina
    sha256 "dcb237738485dcccca47e2dc95fbf6f55a58e53aac697bcb7ee760453a56477a" => :mojave
    sha256 "0bc3018fe6b7ff39517cfc630a699d81857c6c667ed6d1a88290c9c2c28504a8" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
