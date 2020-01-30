# stress-ng: Build a bottle for Linux
class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.10.17.tar.xz"
  sha256 "af82a98d58fa65a21e28f03f1c9d9bacc5db139356dc99c9eae5af0d5c9ea3d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac0f9ca2f2f4d944871d891dd51e6b3efa9d46c20c92f6f4aee241a25054052e" => :catalina
    sha256 "9c54f962f9a6284faff78607b747310e715d3c7c4f277fd9bf8c118edf8ec40c" => :mojave
    sha256 "ea579231243118aea6d75380d2c199ceb75eb2bc17be539ae1f911eea2fbf0c2" => :high_sierra
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
