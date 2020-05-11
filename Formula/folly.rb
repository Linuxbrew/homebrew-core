class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2020.05.04.00.tar.gz"
  sha256 "8c3b373e8423dbecd465bfac0d3a6b2954ba2c20ee3e8babb2c05c5e331b8440"
  head "https://github.com/facebook/folly.git"

  bottle do
    cellar :any
    sha256 "f973d0a921454b5dca403ab199bdef1bf9d690e3c59769d9e5c04be808005423" => :catalina
    sha256 "6f41ea740974a7b06d7f675a1b85e50b18394b6eca46e441667481b67b0254c1" => :mojave
    sha256 "c9fa4b6fe7fe049d88e7547061c33de3dffef9ec335907233eec05b12814844f" => :high_sierra
    sha256 "1b004e701ca8116f42298e78aaafc63f8aa4f4d2f842718a1ff2e5709109295f" => :x86_64_linux
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
