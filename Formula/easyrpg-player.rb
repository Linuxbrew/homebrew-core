class EasyrpgPlayer < Formula
  desc "RPG Maker 2000/2003 games interpreter"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.6.2/easyrpg-player-0.6.2.tar.xz"
  sha256 "3550200c4b7c42fa7bd5774de5016b48d5660cc33d1614f174f474702ee253b9"

  bottle do
    cellar :any
    sha256 "42e4f4c9bfb0976b86352945add0129be8945e72a46ab83b1d0fa1ad78d1aa1e" => :catalina
    sha256 "48697f536c393274f96fde667afc03e59aa0d753b94bf7aa4f671c81cbc16d84" => :mojave
    sha256 "12bff4afc0b160b939e27a9d78a00c94116f29984816d85f26e3423ad47d2562" => :high_sierra
    sha256 "46bf0c2e0ee4addc289d3f2570e2f383507b8bdff1e2dd10cdc116b49c2119c6" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "liblcf"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "libxmp"
  depends_on "mpg123"
  depends_on "pixman"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "speexdsp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /EasyRPG Player #{version}$/, shell_output("#{bin}/easyrpg-player -v")
  end
end
