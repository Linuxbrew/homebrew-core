class Simdjson < Formula
  desc "SIMD-accelerated C++ JSON parser"
  homepage "https://simdjson.org"
  url "https://github.com/simdjson/simdjson/archive/v0.7.0.tar.gz"
  sha256 "c814f7e20103cded7c2758ceaf41f9f63febe8914e7e72dd1daf1d6071aba8f0"
  license "Apache-2.0"
  head "https://github.com/simdjson/simdjson.git"

  bottle do
    cellar :any
    sha256 "c13aaab69e4e1c3389df43b10d50bdafff3f545ebcbde9a53ee261ade98b5c19" => :big_sur
    sha256 "88a0ecf9635836391073055253b0435a875701d16e74c4f94cc8cee0304a96a0" => :catalina
    sha256 "17a38a59364e55a80ea93a96cc11629fe454676649923a66bac7ac8ca9f896bc" => :mojave
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + ["-DSIMDJSON_JUST_LIBRARY=ON"]
    system "cmake", ".", *args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", *args, "-DSIMDJSON_BUILD_STATIC=ON"
    system "make"
    lib.install "src/libsimdjson.a"
  end

  test do
    (testpath/"test.json").write "{\"name\":\"Homebrew\",\"isNull\":null}"
    (testpath/"test.cpp").write <<~EOS
      #include <simdjson.h>
      int main(void) {
        simdjson::dom::parser parser;
        simdjson::dom::element json = parser.load("test.json");
        std::cout << json["name"] << std::endl;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11",
           "-I#{include}", "-L#{lib}", "-lsimdjson", "-o", "test"
    assert_equal "\"Homebrew\"\n", shell_output("./test")
  end
end
