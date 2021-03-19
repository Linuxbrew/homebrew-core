class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-10.3.0.tar.xz"
  sha256 "ab1efffa5af90000a11a19a39302fdfbc5c4abf6fab578a9bd0e9c95cf81e4c7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "87633f001831c082230cb2063a5d3d65e0ebb427c8eacf7ba6165e5e57a33a1c"
    sha256 cellar: :any,                 big_sur:       "4f6b3323680615bc0201fadab0c30786c0b51a83435d80a45414a266e1d6e9d7"
    sha256 cellar: :any,                 catalina:      "79054f3a7d8796857a2d47cb5cbd45801cbdd8cab7307d28c1fd8324ea696ea4"
    sha256 cellar: :any,                 mojave:        "01a98db595c727d16aa976ec0f8e11f77c9b88c074dcce54b3605ed63932b4d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e390af2ff51060de54463a6ef5c60de81daed41fe8d785fd549ed28012397ad2"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "openblas"
  depends_on "superlu"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

    system "cmake", ".", "-DDETECT_HDF5=ON", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
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
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal shell_output("./test").to_i, version.to_s.to_i
  end
end
