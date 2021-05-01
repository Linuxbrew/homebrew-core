class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.14.1-src.tar.gz"
  sha256 "70fd2c1bdaa763378e89c14a554e3b9ab7869ca2334ad34ed2cd6ad3cb37f443"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "00d28f29eec3f6453bf5df9197815d04760a6fa30e6b9aea62c1ca9ccbedf882"
    sha256 cellar: :any,                 big_sur:       "c74d96d3d5bc3ebe206bb4555bd40d8aa5f536f78256458cb2e887575e5918ff"
    sha256 cellar: :any,                 catalina:      "e21fa6b8684979fe16da54e5adb44916fbec23cc8b632757904f48adabed33ec"
    sha256 cellar: :any,                 mojave:        "2a3b4ffca159ef7d59392e54b25ab00e04ea03c2907f8a3a1c52d8cf1a15e5b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99347adcfb7597263c28cc9db7ac8a855b7ab6451c1710cd51c9e7bd0b104e7b"
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
