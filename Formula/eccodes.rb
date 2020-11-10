class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.19.1-Source.tar.gz"
  sha256 "9964bed5058e873d514bd4920951122a95963128b12f55aa199d9afbafdd5d4b"
  license "Apache-2.0"

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 "776e898b7bc2e0ac5702df71ece3e542db8975d9a14cff6481bed1f761a6d535" => :catalina
    sha256 "1c45326fa7887c878d00997bdfff1837c7b9366d7f1ce7fe226111e7b78ff773" => :mojave
    sha256 "bcdea4208f061cf2a11d631821758f4e57896397fb8778bdf0ba68d529d8da24" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    # Fix for GCC 10, remove with next version
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957159
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch" if OS.mac?

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    os = OS.mac? ? "mac" : "linux"
    cc = OS.mac? ? "clang" : "gcc"
    path = HOMEBREW_LIBRARY/"Homebrew/shims/#{os}/super/#{cc}"
    inreplace include/"eccodes_ecbuild_config.h", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes.pc", path, "/usr/bin/#{cc}"
    inreplace lib/"pkgconfig/eccodes_f90.pc", path, "/usr/bin/#{cc}"
  end

  test do
    grib_samples_path = shell_output("#{bin}/codes_info -s").strip
    assert_match "packingType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB1.tmpl")
    assert_match "gridType", shell_output("#{bin}/grib_ls #{grib_samples_path}/GRIB2.tmpl")
  end
end
