class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  url "https://dl.bintray.com/homebrew/mirror/ImageMagick-7.0.10-23.tar.xz"
  mirror "https://www.imagemagick.org/download/releases/ImageMagick-7.0.10-23.tar.xz"
  sha256 "882cecda27265526eb4e7ce7e2cf6f74c018bcbbd34bc9ddd3c67fb3e9184103"
  head "https://github.com/ImageMagick/ImageMagick.git"

  bottle do
    sha256 "bf19ce6c826be9ab5a42d4e02b74d2f6cd8f5d9402276dae5428ac3c1dc08c6d" => :catalina
    sha256 "d2acf6bbf71aa2128b30feb968f19b96e9b0878700bebe15c2cbe2523a76f631" => :mojave
    sha256 "9ce075b1ff714f828747d6b564d95c85d269795b75bbcd6129bd3628ea596b60" => :high_sierra
    sha256 "4d1853445767702394053f16c50a5e63f5d8fd1b5c7384c8c8d90c800ed46d93" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "liblqr"
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
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

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
      --with-gslib
      --with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts
      --with-lqr
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
    assert_match "Helvetica", shell_output("#{bin}/identify -list font")
  end
end
