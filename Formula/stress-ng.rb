# stress-ng: Build a bottle for Linux
class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.14.tar.xz"
  sha256 "d8ba86ddfcf4695389575ae0d426d7681b03d1803bf8f19c691d7e4c73975f51"

  bottle do
    cellar :any_skip_relocation
    sha256 "e52795fd0d34109f2eb431b6d84000559ee898c1e56e2e9ba1cbe8cd7711e9b1" => :catalina
    sha256 "921174484d1907176a15602ed29ee281ff2a60266a5436cca78e02daaeccb80b" => :mojave
    sha256 "ac5bb01106618d99e6b503ab019c17cd74105a6aba77635369acf123c144c26b" => :high_sierra
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
