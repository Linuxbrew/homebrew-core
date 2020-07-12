class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.15.tar.xz"
  sha256 "6a333650fb5c85c5221f10d2cf890e9fc56530696e118d975fbbe96126c06963"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f30e1fb424317a47506a72e4927688de9d6d43a9ba151fe4195af485cd8aa34" => :catalina
    sha256 "e763ad0f9fa7f5b9589df62bf12b7d781faa0bf7ccb425acec4b7c9e2ee88688" => :mojave
    sha256 "b54ae221f7530f799324145eb0232b532aa5ee828ce0b5f12e92ccdfa2f58d66" => :high_sierra
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on :macos => :sierra
  end

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
