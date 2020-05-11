class OpenImageDenoise < Formula
  desc "High-performance denoising library for ray tracing"
  homepage "https://openimagedenoise.github.io"
  url "https://github.com/OpenImageDenoise/oidn/releases/download/v1.2.0/oidn-1.2.0.src.tar.gz"
  sha256 "041f59758e79f4ea29a9b7a952f2c096426820678a5a713880b6d8a6519a75d0"

  bottle do
    cellar :any
    sha256 "dd30425462d2fc4c19e8ab4c3fd0b3b2b6d27fe47dab7c5d50b342d58e721abe" => :catalina
    sha256 "e8c5f77201fe5321915bbed725d88e3cab4cd44ed13d3a80a2243b35f0e83b73" => :mojave
    sha256 "21c0dafc5a87978537a55dda39e62c056e498db093cc5ff0e2a7e2a5b486bcc8" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  # clang: error: unknown argument: '-fopenmp-simd'
  # https://github.com/OpenImageDenoise/oidn/issues/35
  depends_on :macos => :high_sierra
  depends_on "tbb"

  # ispc 1.13 compatibility
  patch do
    url "https://github.com/OpenImageDenoise/oidn/commit/e321d7c90a2c706a521a3afd8913af36b121dc9e.patch?full_index=1"
    sha256 "7b5a09fff4339893f2a595163421fe9b63e4e0ce8fded13d5507ff98b1fd46b6"
  end

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <OpenImageDenoise/oidn.h>
      int main() {
        OIDNDevice device = oidnNewDevice(OIDN_DEVICE_TYPE_DEFAULT);
        oidnCommitDevice(device);
        return oidnGetDeviceError(device, 0);
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lOpenImageDenoise"
    system "./a.out"
  end
end
