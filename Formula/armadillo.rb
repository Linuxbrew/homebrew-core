# armadillo: Build a bottle for Linux
class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.800.3.tar.xz"
  sha256 "a481e1dc880b7cb352f8a28b67fe005dc1117d4341277f12999a2355d40d7599"
  revision 1

  bottle do
    cellar :any
    sha256 "c0828bef4a3f09a677d3175b08b929a715c6950a7bfe92e1d99f663d5586c139" => :catalina
    sha256 "2337c93d100d7c9d99c26bb16f2febd9012e63866d067f6a53a33556f7280f0f" => :mojave
    sha256 "b30fb41ebb42c99c9d76f5301a7d3e5a0194a4bc6f69fc5fccad367a31439c12" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

  def install
    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal Utils.popen_read("./test").to_i, version.to_s.to_i
  end
end
