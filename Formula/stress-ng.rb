class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.12.12.tar.xz"
  sha256 "f27af50f6f2308e707fef927674bdd209a046b116734281b792aeca35a4e4499"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/"
    regex(/href=.*?stress-ng[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "887a059ac792b16b65e24481d476305173cbb5020b5ee12632b7bd336a0f6450"
    sha256 cellar: :any_skip_relocation, big_sur:       "f43d0d4e111ae2fc6ed724577d0cf1dac6a317077a7642e280489721b6bf826c"
    sha256 cellar: :any_skip_relocation, catalina:      "38467912fc8a91f31470bb98b77d87ccc415bbc5c7c858090a4d88e572723464"
    sha256 cellar: :any_skip_relocation, mojave:        "77f4ae0c4bdc843802c80055f4ea348a1d61220764f77903ed5d003a9908c6c0"
  end

  uses_from_macos "zlib"

  on_macos do
    depends_on macos: :sierra
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
