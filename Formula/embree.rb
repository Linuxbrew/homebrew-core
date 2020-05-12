class Embree < Formula
  desc "High-performance ray tracing kernels"
  homepage "https://embree.github.io/"
  url "https://github.com/embree/embree/archive/v3.10.0.tar.gz"
  sha256 "7af744b2c3a2f60aa54cdfcf7928c56f59aabec4a7310dbb96b09a6c64a5a7b0"
  head "https://github.com/embree/embree.git"

  bottle do
    cellar :any
    sha256 "13272fc2fe1996369bdcbe4378fc91af40bc0013f55532fdfe5aaa316ff8f39a" => :catalina
    sha256 "381fee059999b460ced05497fbccb93104d34d77fb04d76c45b70c20a6ec9196" => :mojave
    sha256 "ac55262ccec286e6c322d739aa5a32672a0866ebd2f9a215b76630155fe9dd6c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "ispc" => :build
  depends_on "tbb"
  depends_on "gcc" unless OS.mac?

  def install
    max_isa = (!OS.mac? || MacOS.version.requires_sse42?) ? "SSE4.2" : "SSE2"

    args = std_cmake_args + %W[
      -DBUILD_TESTING=OFF
      -DEMBREE_IGNORE_CMAKE_CXX_FLAGS=OFF
      -DEMBREE_ISPC_SUPPORT=ON
      -DEMBREE_MAX_ISA=#{max_isa}
      -DEMBREE_TUTORIALS=OFF
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "make"
      system "make", "install"
    end

    # Remove bin/models directory and the resultant empty bin directory since
    # tutorials are not enabled.
    rm_rf bin
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <embree3/rtcore.h>
      int main() {
        RTCDevice device = rtcNewDevice("verbose=1");
        assert(device != 0);
        rtcReleaseDevice(device);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lembree3"
    system "./a.out"
  end
end
