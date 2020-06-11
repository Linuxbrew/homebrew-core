class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.13.tar.xz"
  sha256 "adca2b21dc897e4193f3c358d459d2ef2254418a0e3dd0c208e2c94d20371be3"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec9c912a17f21cfb6f060f228fc834cbfa47536725f2a6d01b3e4c85696c7bcf" => :catalina
    sha256 "085fc372c87a3aeb8374cc9cca894eb37675c3e3d0a2a93e7e4b6f1a20531935" => :mojave
    sha256 "5b3b204b15f649f47273aadc697915ab91b90751043f52adeeb78974700a4083" => :high_sierra
  end

  depends_on :macos => :sierra

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
