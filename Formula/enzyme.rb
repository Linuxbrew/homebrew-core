class Enzyme < Formula
  desc "High-performance automatic differentiation of LLVM"
  homepage "https://enzyme.mit.edu"
  url "https://github.com/wsmoses/Enzyme/archive/v0.0.10.tar.gz"
  sha256 "6fcee5390541e259f26def103f0423df990ebf364933cf2a3610a08de3b0691f"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/wsmoses/Enzyme.git", branch: "main"

  bottle do
    sha256 arm64_big_sur: "10f79a7540a0956a573bcda66b1eae22f223372e14e64ca4a61464f8bef5c164"
    sha256 big_sur:       "9195580c8f11547a403dd287a8d3dc26c06d3cbc5ea7dcb9d4422c6775b84923"
    sha256 catalina:      "c11172e277a94256c5edaee31916b66cf30bde5fd17bc81edd393a2a61f7f78a"
    sha256 mojave:        "ea4bb0a0bf3a77cc03321a0a6c619eeb668410994dade551a0094a2c4182274a"
  end

  depends_on "cmake" => :build
  depends_on "llvm@11"

  def install
    mkdir "build" do
      system "cmake", "../enzyme", *std_cmake_args, "-DLLVM_DIR=#{Formula["llvm@11"].opt_lib}/cmake/llvm"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      extern double __enzyme_autodiff(void*, double);
      double square(double x) {
        return x * x;
      }
      double dsquare(double x) {
        return __enzyme_autodiff(square, x);
      }
      int main() {
        double i = 21.0;
        printf("square(%.0f)=%.0f, dsquare(%.0f)=%.0f\\n", i, square(i), i, dsquare(i));
      }
    EOS

    llvm = Formula["llvm@11"]
    opt = llvm.opt_bin/"opt"
    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, testpath/"test.c", "-S", "-emit-llvm", "-o", "input.ll", "-O2",
                   "-fno-vectorize", "-fno-slp-vectorize", "-fno-unroll-loops"
    system opt, "input.ll", "-load=#{opt_lib}/#{shared_library("LLVMEnzyme-#{llvm.version.major}")}",
                "-enzyme", "-o", "output.ll", "-S"
    system ENV.cc, "output.ll", "-O3", "-o", "test"

    assert_equal "square(21)=441, dsquare(21)=42\n", shell_output("./test")
  end
end
