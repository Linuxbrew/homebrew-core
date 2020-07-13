class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2020.07.06.00.tar.gz"
  sha256 "ed5d8b6a9117de99eec62c66ceecfa3dfc4c44f3e51035aabd935a4efa7b88c2"
  license "Apache-2.0"
  revision 1
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "b5e26f8b06c8300033db5160fa2c774645cd9a7beedae49d1c8cba407dcc622a" => :catalina
    sha256 "a6fc7064aee0925074ccd1080bc5062731f86cf0f7d3ad151c0d218e91eeee78" => :mojave
    sha256 "036b07550fb13b71a7cc4301348e195ab42f2188ade544fe746276308e2548a2" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  # https://github.com/facebook/folly/issues/966
  depends_on :macos => :high_sierra if OS.mac?

  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"
  unless OS.mac?
    depends_on "jemalloc"
    depends_on "python"
  end

  def install
    mkdir "_build" do
      args = std_cmake_args
      args << "-DFOLLY_USE_JEMALLOC=#{OS.mac? ? "OFF" : "ON"}"

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON", ("-DCMAKE_POSITION_INDEPENDENT_CODE=ON" unless OS.mac?)
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
