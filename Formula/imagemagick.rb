# imagemagick: Build a bottle for Linux
class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.9-17.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-7.0.9-17.tar.xz"
  sha256 "e926b494fd0c7faa51f5fc1da40cda87f62f5fa4e77c9bcc0f15c3bfa1e42ed3"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "29c7a3bb1cd484f468e0a891fe7f46ea1eb6828a46c2d978805b51b1b4d58d14" => :catalina
    sha256 "80c85f1ca2b6a74e2b477e4f75cce5f565041e6dd65357ef0da91b634fb3e815" => :mojave
    sha256 "3b8c18a4ccf3d0b4afcf3989527a545b78d919affc29df94e1a2488abf86f2e1" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"
  uses_from_macos "bzip2"
  uses_from_macos "libxml2"

  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-opencl
      --enable-shared
      --enable-static
      --with-freetype=yes
      --with-modules
      --with-openjp2
      --with-openexr
      --with-webp=yes
      --with-heic=yes
      --without-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --without-fftw
      --without-pango
      --without-x
      --without-wmf
      --enable-openmp
      ac_cv_prog_c_openmp=-Xpreprocessor\ -fopenmp
      ac_cv_prog_cxx_openmp=-Xpreprocessor\ -fopenmp
      LDFLAGS=-lomp
    ]

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
  end
end
