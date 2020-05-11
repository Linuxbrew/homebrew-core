class Libpulsar < Formula
  desc "Apache Pulsar C++ library"
  homepage "https://pulsar.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pulsar/pulsar-2.5.1/apache-pulsar-2.5.1-src.tar.gz"
  mirror "https://archive.apache.org/dist/pulsar/pulsar-2.5.1/apache-pulsar-2.5.1-src.tar.gz"
  sha256 "e269744fc549db7775d9c6e6e0022ec67b42301264e29b8e8e29d1340047f035"

  bottle do
    cellar :any
    sha256 "da5e0215ca5c0d10c8271575555b225a7b0dc48fef1be73941832cd2002ba97a" => :catalina
    sha256 "92b3f55782789d455f0bec4b311f9f0c409ff0168c24f588ef34fa8878c218db" => :mojave
    sha256 "65c1a5c6e15e3b7ab044ff89818d50889421a3c6a24ded1b1ba6a24383c78386" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "snappy"
  depends_on "zstd"

  def install
    cd "pulsar-client-cpp" do
      system "cmake", ".", *std_cmake_args,
                      "-DBUILD_TESTS=OFF",
                      "-DBUILD_PYTHON_WRAPPER=OFF",
                      "-DBoost_INCLUDE_DIRS=#{Formula["boost"].include}",
                      "-DProtobuf_INCLUDE_DIR=#{Formula["protobuf"].include}",
                      "-DProtobuf_LIBRARIES=#{Formula["protobuf"].lib}/libprotobuf.dylib"
      system "make", "pulsarShared", "pulsarStatic"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pulsar/Client.h>

      int main (int argc, char **argv) {
        pulsar::Client client("pulsar://localhost:6650");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cc", "-L#{lib}", "-lpulsar", "-o", "test"
    system "./test"
  end
end
