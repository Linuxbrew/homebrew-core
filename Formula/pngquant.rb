class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.13.0-src.tar.gz"
  sha256 "0d1d5dcdb5785961abf64397fb0735f8a29da346b6fee6666e4ef082b516c07e"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "ac9a63953788be2e15e1215b32f3280dcaa4beaebeae7f239247616d9186f7d8" => :big_sur
    sha256 "cad350e78adc1912e1895b2f1c4abaf27bd14db902bad179424580934b9e1a05" => :catalina
    sha256 "60f111e8252d2480df50d6fc77e2938c50480dc03e00207a75033b882cbeb740" => :mojave
    sha256 "eb2b662bda1612dece961a7809ea5336997a00354fe204a001b4191b5b658fed" => :high_sierra
    sha256 "f4ff93bf03006bd15d2e93e0c3ed3acbba7c677e53421ed2fa728fb47fffa275" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
