class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.2.tar.gz"
  sha256 "1a98c37c946c00232fa7319d00d1d80f77603adda7c9239d10d68a8a3545a4d5"

  bottle do
    cellar :any
    sha256 "a8ada0f03e67bacdb7d5fc8dc572d08af7804cee954158f7aa1cb78889030dd8" => :catalina
    sha256 "bc239152f144e88284c1fcd374b32302919b36581e2d4ae75a25b591f8a6df75" => :mojave
    sha256 "698d55278ea837b501d4755f0395b39cc055dc50a05f94c40afbe18d1da15c42" => :high_sierra
  end

  head do
    url "https://github.com/nco/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource "example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
