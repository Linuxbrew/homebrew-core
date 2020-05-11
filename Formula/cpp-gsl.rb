class CppGsl < Formula
  desc "Microsoft's C++ Guidelines Support Library"
  homepage "https://github.com/Microsoft/GSL"
  url "https://github.com/Microsoft/GSL/archive/v3.0.1.tar.gz"
  sha256 "7ceba191e046e5347357c6b605f53e6bed069c974aeda851254cb6962a233572"
  head "https://github.com/Microsoft/GSL.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :catalina
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :mojave
    sha256 "0e9dfbc376a213a6208fce22c4070ffd0ac7647f1304e97e5ddb01494c86bc0b" => :high_sierra
    sha256 "ea944369c4918ddc9c66068ba4368e074b56a6934013e0aec7eeb0a3979a5f51" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DGSL_TEST=false", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gsl/gsl>
      int main() {
        gsl::span<int> z;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14"
    system "./test"
  end
end
