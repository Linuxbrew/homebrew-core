class Imath < Formula
  desc "Library of 2D and 3D vector, matrix, and math operations"
  homepage "https://www.openexr.com/"
  url "https://github.com/AcademySoftwareFoundation/Imath/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "38b94c840c6400959ccf647bc1631f96f3170cb081021d774813803e798208bd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "380189584c4b8acd2e776ac157c5c4d40fde86361e27913a2f35cef8027a6cf4"
    sha256 cellar: :any,                 big_sur:       "dc1caaac49ebc5c4cd0f8a120102c513a101bf6f2cef0ff45972db5d8a2a6a5c"
    sha256 cellar: :any,                 catalina:      "799ecbff5b86f6c8167c41e5abbaebf41acade96d9c311ff53fa2af8244c44c4"
    sha256 cellar: :any,                 mojave:        "3280110f29ee186b8ab8463c81dd8305de8c8388815ceda75ba27ae21666704a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbfc99d2b81f9241d79409e2f437db9750f34f4e7e6e8332ea05e8f315458b67" # linuxbrew-core
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
    system ENV.cxx, "-std=c++11", "-I#{include}/Imath", "-o", testpath/"test", "test.cpp"
    assert_equal "2, -2, -1\n", shell_output("./test")
  end
end
