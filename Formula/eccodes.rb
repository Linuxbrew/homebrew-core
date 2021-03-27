class Eccodes < Formula
  desc "Decode and encode messages in the GRIB 1/2 and BUFR 3/4 formats"
  homepage "https://confluence.ecmwf.int/display/ECC"
  url "https://software.ecmwf.int/wiki/download/attachments/45757960/eccodes-2.21.0-Source.tar.gz"
  sha256 "da0a0bf184bb436052e3eae582defafecdb7c08cdaab7216780476e49b509755"
  license "Apache-2.0"

  livecheck do
    url "https://software.ecmwf.int/wiki/display/ECC/Releases"
    regex(/href=.*?eccodes[._-]v?(\d+(?:\.\d+)+)-Source\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "f74b5bb384bce5589fd3af3146782b4a0fb4698c3b5e12d29a349ea2b73262e7"
    sha256 big_sur:       "791862aed908852b7588bd8c0cf33bd38f9eda6491e14f0fde72c768f7cc1240"
    sha256 catalina:      "de0339d06a0774e858a76ecfd2a156e69d056e9e181862bf6ca621a397bff466"
    sha256 mojave:        "15be2853b5d08d8e6e8a6bc091299c21eac59762985aa3fed39071aa975c6d3f"
    sha256 x86_64_linux:  "a58b99353ce98f1cd5acd82b6b6d2d0dfff742ef6c0e84e18dcc4597d8237be6"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "jasper"
  depends_on "libpng"
  depends_on "netcdf"

  def install
    # Fix for GCC 10, remove with next version
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=957159
    ENV.prepend "FFLAGS", "-fallow-argument-mismatch"

    inreplace "CMakeLists.txt", "find_package( OpenJPEG )", ""

    mkdir "build" do
      system "cmake", "..", "-DENABLE_NETCDF=ON", "-DENABLE_PNG=ON",
                            "-DENABLE_PYTHON=OFF", "-DENABLE_ECCODES_THREADS=ON",
                             *std_cmake_args
      system "make", "install"
    end

    # Avoid references to Homebrew shims directory
    os = OS.mac? ? "mac" : "linux"
    cc = OS.mac? ? "clang" : "gcc-5"
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
