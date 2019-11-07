# stress-ng: Build a bottle for Linux
class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.09.tar.xz"
  sha256 "06c633871584d7dc2f43c6b3553f727008b7dc0dc5bfceb4260684dedbe00624"

  bottle do
    cellar :any_skip_relocation
    sha256 "80621905ab2acb16c64ca0a5e317c9f0318e359e8ef829cc1fbc828846f6dbd6" => :catalina
    sha256 "d74b340a03070a8d671ec68e6da62fbb9f6825dd00421abd47d29a8a1b5c36da" => :mojave
    sha256 "f180c3a0c6045a956e700a6498492c9a2dcfbd06eba6d1e721a1fec975fb9773" => :high_sierra
  end

  depends_on :macos => :sierra if OS.mac?
  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "/usr", prefix
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end
