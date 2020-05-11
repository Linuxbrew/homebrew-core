class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-9.870.2.tar.xz"
  sha256 "541b5fee4c1c412d0a508791611583fcd4e8ff67c0da0536833e694e700cf756"

  bottle do
    cellar :any
    sha256 "72582d2bfbcc6cc30bfda48af05e35778d84d985f0806f162afcaf0bad847be4" => :catalina
    sha256 "0f237a879ad3fe27443efb3a0dfcb5a054168e5ba8e0306f5bad3c7e3855e421" => :mojave
    sha256 "e1bd618d408c96e1c75b7c87d2ad0e5ce567a4e517ed7f9626ea68ce8b702c57" => :high_sierra
    sha256 "6549490aad7af7defcc3c9030a23d49a5d59cc2ec2069e5ccce35ff1e8971b07" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "arpack"
  depends_on "hdf5"
  depends_on "szip"

  def install
    ENV.prepend "CXXFLAGS", "-DH5_USE_110_API -DH5Ovisit_vers=1"

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
