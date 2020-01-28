# mkl-dnn: Build a bottle for Linux
class MklDnn < Formula
  desc "Intel Math Kernel Library for Deep Neural Networks"
  homepage "https://01.org/mkl-dnn"
  url "https://github.com/intel/mkl-dnn/archive/v1.1.3.tar.gz"
  sha256 "0e9bcbc86cc215a84a5455a395ce540c68e255eaa586e37222fff622b9b17df7"

  bottle do
    cellar :any
    sha256 "cd888534dcdd775de0ec4075e3b951406acdc82e225fef88b0b1500f13af8368" => :catalina
    sha256 "c60c13dabfd4123432023bbd7bc2cd364e5346dde91569fb4a12eed7b248621f" => :mojave
    sha256 "a09904f62bec73760362141c0d2f4da4324f77172bd8f14fc0d1019d9995dbed" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "doc"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mkldnn.h>
      int main() {
        mkldnn_engine_t engine;
        mkldnn_status_t status = mkldnn_engine_create(&engine, mkldnn_cpu, 0);
        return !(status == mkldnn_success);
      }
    EOS
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lmkldnn", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-L#{lib}", "-lmkldnn", "-o", "test"
    end
    system "./test"
  end
end
