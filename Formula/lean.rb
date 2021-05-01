class Lean < Formula
  desc "Theorem prover"
  homepage "https://leanprover-community.github.io/"
  url "https://github.com/leanprover-community/lean/archive/v3.29.0.tar.gz"
  sha256 "ab7a9fbe13de048126b1607025d40e7e7cf51f663a85453d55c7799be5bdddac"
  license "Apache-2.0"
  head "https://github.com/leanprover-community/lean.git"

  # The Lean 3 repository (https://github.com/leanprover/lean/) is archived
  # and there won't be any new releases. Lean 4 is being developed but is still
  # a work in progress: https://github.com/leanprover/lean4
  livecheck do
    skip "Lean 3 is archived; add a new check once Lean 4 is stable"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "4bc6829c4bd04da5b824636f38cc33b28a91b6c0897623b979cfa7047d70c74a"
    sha256 cellar: :any,                 big_sur:       "d3535e7716eb63e12b18814158bcd71831df116732a3b1b31d9f5b538570bb1d"
    sha256 cellar: :any,                 catalina:      "1c311fa94cdef29fa311e97112c94342f292017584767fda2b1327f01dfd5151"
    sha256 cellar: :any,                 mojave:        "b71d9c9389dddada7c4cb26559258515f2d270b3bd548c0d6776270722118687"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19763a3b169fe9a0954dfd7bd96e87cf4a1c1e58c090e7425dbabebf4c3b47af"
  end

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "jemalloc"
  depends_on macos: :mojave

  def install
    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.lean").write <<~EOS
      def id' {α : Type} (x : α) : α := x

      inductive tree (α : Type) : Type
      | node : α → list tree → tree

      example (a b : Prop) : a ∧ b -> b ∧ a :=
      begin
          intro h, cases h,
          split, repeat { assumption }
      end
    EOS
    system "#{bin}/lean", testpath/"hello.lean"
  end
end
