class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://kernel.ubuntu.com/~cking/stress-ng/"
  url "https://kernel.ubuntu.com/~cking/tarballs/stress-ng/stress-ng-0.11.08.tar.xz"
  sha256 "07090ed5aef4e8d406f9c1927fc816db1068ab02d3aa53120481b14872a9c5f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "15fa554b06eb0f2f615059422f9d6cc4562f341dcecb7abde5d8f7b1756f003a" => :catalina
    sha256 "624c9544177c97255a70e23b8a3eacc55a7463e271f7cbec7f7077e70cc8fb39" => :mojave
    sha256 "a77852b3afab08fee5d8794f5eb469e290d91060d749d550e4b607a687ee443b" => :high_sierra
    sha256 "17bd065acd0e861de87f0f279e7840e644d920146ce565ef9c357facb9e86911" => :x86_64_linux
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
