# imagemagick@6: Build a bottle for Linuxbrew
class ImagemagickAT6 < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://www.imagemagick.org/"
  # Please always keep the Homebrew mirror as the primary URL as the
  # ImageMagick site removes tarballs regularly which means we get issues
  # unnecessarily and older versions of the formula are broken.
  url "https://dl.bintray.com/homebrew/mirror/imagemagick%406-6.9.9-6.tar.xz"
  mirror "https://www.imagemagick.org/download/ImageMagick-6.9.9-6.tar.xz"
  sha256 "99ad9eed5291b149cf20d91b1b87c81f65d76882d8d3e0b63d3773acd5481ef3"

  bottle do
    sha256 "787da13a7e5e38c23e013cde966c5485b6c6415ce15217f8e209ed78a17ba5b4" => :sierra
    sha256 "6eaf1a9fc9db7f65ceb46a4e93916516d3a95c7819cdea68a0a101293604aae9" => :el_capitan
    sha256 "9506d50bd570922d1d2b5c0f8934eb7f689ce7501bbe507419de5acd8713a15c" => :yosemite
  end

  keg_only :versioned_formula

  option "with-fftw", "Compile with FFTW support"
  option "with-hdri", "Compile with HDRI support"
  option "with-opencl", "Compile with OpenCL support"
  option "with-openmp", "Compile with OpenMP support"
  option "with-perl", "Compile with PerlMagick"
  option "without-magick-plus-plus", "disable build/install of Magick++"
  option "without-modules", "Disable support for dynamically loadable modules"
  option "without-threads", "Disable threads support"
  option "with-zero-configuration", "Disables depending on XML configuration files"

  deprecated_option "enable-hdri" => "with-hdri"
  deprecated_option "with-jp2" => "with-openjpeg"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "xz"

  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "freetype" => :recommended

  depends_on "fontconfig" => :optional
  depends_on "little-cms" => :optional
  depends_on "little-cms2" => :optional
  depends_on "libwmf" => :optional
  depends_on "librsvg" => :optional
  depends_on "liblqr" => :optional
  depends_on "openexr" => :optional
  depends_on "ghostscript" => :optional
  depends_on "webp" => :optional
  depends_on "openjpeg" => :optional
  depends_on "fftw" => :optional
  depends_on "pango" => :optional
  depends_on :perl => ["5.5", :optional]

  needs :openmp if build.with? "openmp"

  skip_clean :la

  def install
    args = %W[
      --disable-osx-universal-binary
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-shared
      --enable-static
    ]

    if build.without? "modules"
      args << "--without-modules"
    else
      args << "--with-modules"
    end

    if build.with? "opencl"
      args << "--enable-opencl"
    else
      args << "--disable-opencl"
    end

    if build.with? "openmp"
      args << "--enable-openmp"
    else
      args << "--disable-openmp"
    end

    if build.with? "webp"
      args << "--with-webp=yes"
    else
      args << "--without-webp"
    end

    if build.with? "openjpeg"
      args << "--with-openjp2"
    else
      args << "--without-openjp2"
    end

    args << "--without-gslib" if build.without? "ghostscript"
    args << "--with-perl" << "--with-perl-options='PREFIX=#{prefix}'" if build.with? "perl"
    args << "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts" if build.without? "ghostscript"
    args << "--without-magick-plus-plus" if build.without? "magick-plus-plus"
    args << "--enable-hdri=yes" if build.with? "hdri"
    args << "--without-fftw" if build.without? "fftw"
    args << "--without-pango" if build.without? "pango"
    args << "--without-threads" if build.without? "threads"
    args << "--with-rsvg" if build.with? "librsvg"
    args << "--without-x" if build.without? "x11"
    args << "--with-fontconfig=yes" if build.with? "fontconfig"
    args << "--with-freetype=yes" if build.with? "freetype"
    args << "--enable-zero-configuration" if build.with? "zero-configuration"

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
