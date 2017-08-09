class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-7.960.0.tar.xz"
  sha256 "8ea919c4312ec43d454f61fdd0e34282f94739eb51adc78d21176717143cfd32"

  bottle do
    cellar :any
    sha256 "ea5934206eaad18779f7d0aeb11d25db487f0e4254646aa0445212c6fe4e4799" => :sierra
    sha256 "0399afccee447fc70bd3b9a4efd88edb689927baa9323e7a2196f7488313b7c9" => :el_capitan
    sha256 "7f68b75cfd32dd7da7b1d622af91b6ebd9fc190db5e15afe9e23ee8aa7f922dd" => :yosemite
  end

  option :cxx11

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "superlu"
  depends_on "openblas" if OS.linux?

  def install
    ENV.cxx11 if build.cxx11?

    system "cmake", ".", "-DDETECT_HDF5=ON", *std_cmake_args
    system "make", "install"

    prefix.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <iostream>
      #include <armadillo>
      using namespace std;
      using namespace arma;

      int main(int argc, char** argv)
        {
        cout << arma_version::as_string() << endl;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal `./test`.to_i, version.to_s.to_i
  end
end
