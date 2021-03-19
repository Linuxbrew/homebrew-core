class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.5.4.tar.gz"
  sha256 "b4b4ae248140b7d6399c6fd5d28e754b9e3d28300773232b165aa272f2922645"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "9256946ee7ba953c1bf1044f8fdc3fa6f90f5e99aedeea1d9fd84ee503b09893"
    sha256 cellar: :any,                 big_sur:       "e496b615ec3bcdb6492dd4a2378f27f5c951e88893f8b363a398d9af310c8df2"
    sha256 cellar: :any,                 catalina:      "ab12b7b6f4d83c01b8acad60f752c241e279eba8c04cdd1d8eddca279d1ee999"
    sha256 cellar: :any,                 mojave:        "54a3283ef836d4efb4c121fbd5941ef37ef1de9ea8186d1ca5cee8ff427d64b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca48b99db532d63e3323bc74e9f7e81c88521f9fa05ab7fde2ffa03f0fe66c7"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
