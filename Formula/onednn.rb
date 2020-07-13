class Onednn < Formula
  desc "Basic building blocks for deep learning applications"
  homepage "https://01.org/oneDNN"
  url "https://github.com/oneapi-src/onednn/archive/v1.5.1.tar.gz"
  sha256 "aef4d2a726f76f5b98902491a1a4ac69954039aa8e5a1d67ef6ce58ed00e23a6"
  head "https://github.com/oneapi-src/onednn.git"

  bottle do
    cellar :any
    sha256 "bcb6c748b97370fea41fb730f939e5cd33bd2b9d486fe997dd5fcb948786835e" => :catalina
    sha256 "a23e16f86f51179216af505fcb90915e4052d5b88a2ccbc38d3e28a9049fe967" => :mojave
    sha256 "f0f53d3f8d772f451cec3c9da678acdc9a0f3f4202e5ebba29a10272cebeafa8" => :high_sierra
    sha256 "823c56bc41882fe2aeaef8987b2dcfec01433341559c5d9e2d1b97e62c43f6df" => :x86_64_linux
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
