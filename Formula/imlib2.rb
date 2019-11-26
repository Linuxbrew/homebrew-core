# imlib2: Build a bottle for Linux
class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.5.1/imlib2-1.5.1.tar.bz2"
  sha256 "fa4e57452b8843f4a70f70fd435c746ae2ace813250f8c65f977db5d7914baae"
  revision 1

  bottle do
    sha256 "d4b9918e30a1126f1b9a1b6372cdd2c013e17355e917ec283ea0f792df2328c8" => :catalina
    sha256 "05b8a89744caac23ef9cb95c1e75a19e8ff127023eb786db4c20c146d3e33743" => :mojave
    sha256 "cbbefadfe4a7d6a8a7df2f66251fccfc2973808d8cbeb48f8cef8c1b1ef9ff1d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :x11 if OS.mac?
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
