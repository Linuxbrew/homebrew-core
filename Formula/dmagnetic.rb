class Dmagnetic < Formula
  desc "Magnetic Scrolls Interpreter"
  homepage "https://www.dettus.net/dMagnetic/"
  url "https://www.dettus.net/dMagnetic/dMagnetic_0.22.tar.bz2"
  sha256 "53905c8a1a69c5c69a7afcac5d0368edc6c214fc603f3d76313e4f33faeb0431"

  bottle do
    cellar :any_skip_relocation
    sha256 "e852de4f215f98be5c5a8b661af2b1169f41d0ca96f0060f4a45a3cf14d853ab" => :catalina
    sha256 "3ded9902642fbce1800f3516fce3766ed39762791453d6b12d945af1095f5cfe" => :mojave
    sha256 "86336f5f6d27927b9915dc73eded254ca529c06d7cdd75f95a94115762d4a162" => :high_sierra
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
    (share/"games/dMagnetic").install "testcode/minitest.mag", "testcode/minitest.gfx"
  end

  test do
    assert_match "2d90033c199915d2f4d4ecc964121928", \
      shell_output("echo Hello | #{bin}/dMagnetic -ini "\
        "#{share}/games/dMagnetic/dMagnetic.ini -mag "\
        "#{share}/games/dMagnetic/minitest.mag -gfx "\
        "#{share}/games/dMagnetic/minitest.gfx | md5").strip
  end
end
