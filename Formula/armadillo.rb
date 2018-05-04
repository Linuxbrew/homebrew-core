# armadillo: Build a bottle for Linuxbrew
class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-8.500.0.tar.xz"
  sha256 "f51c69f45cfbd4773c77ded333c8ff9cdd9a8e0d5a1c011b6a0333ab4b8cbbf1"
  revision 1

  bottle do
    cellar :any
    sha256 "43931c4a3490ca67c7728a3d3ffa6ebf02c935d87a31ecc9c9371525fce04c5c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"

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
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end
