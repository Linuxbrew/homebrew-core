class Ilmbase < Formula
  desc "OpenEXR ILM Base libraries (high dynamic-range image file format)"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.2.tar.gz"
  sha256 "5da8dff448d0c4a529e52c97daf238a461d01cd233944f75095668d6d7528761"
  license "BSD-3-Clause"

  bottle do
    sha256 "13a8f951e15caa1f4f633ec718e4f5b9c19d741a6e8ec2c015f1c59d466f2005" => :catalina
    sha256 "f21663911237058c5c531d806456ebc23e30020f838145d8b13010515364647a" => :mojave
    sha256 "854208849e5fa1be263e25031ad21308582d57999c643baef67b8ec40d32cfb3" => :high_sierra
    sha256 "5ad2d370198a62a04b628345820a05d325ced0358813a10a47619d8c12245ddc" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    cd "IlmBase" do
      system "cmake", ".", *std_cmake_args, "-DBUILD_TESTING=OFF"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~'EOS'
      #include <ImathRoots.h>
      #include <algorithm>
      #include <iostream>

      int main(int argc, char *argv[])
      {
        double x[2] = {0.0, 0.0};
        int n = IMATH_NAMESPACE::solveQuadratic(1.0, 3.0, 2.0, x);

        if (x[0] > x[1])
          std::swap(x[0], x[1]);

        std::cout << n << ", " << x[0] << ", " << x[1] << "\n";
      }
    EOS
    system ENV.cxx, "-I#{include}/OpenEXR", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
