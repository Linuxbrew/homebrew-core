# imlib2: Build a bottle for Linux
class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.6.0/imlib2-1.6.0.tar.bz2"
  sha256 "cfc440ddfaed5fc85ba2572ad8d87a87cd77a5bffb33ebca882c42cefcd8691d"

  bottle do
    sha256 "9db8828f5bdcf1e66053cf5fc4b7e8c0e23d092c2db84a5a8d657be20ab26515" => :catalina
    sha256 "573b4531211a05e3a6248736af333e9964fc5b6ae64dd25c99b5cb9fc75fb729" => :mojave
    sha256 "8bde43cdec3e8b5195ef574901be09c6b414755161a725637d3a7a90b3a326a7" => :high_sierra
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
