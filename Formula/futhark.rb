class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.19.7.tar.gz"
  sha256 "11568521448fdbb5299eeaba1bb9b926638219df2598ca0eb2ed5f83d4e9f806"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64a5eaa6ab01c1d50489767cfa286629580b851145a063c2d9d6a1fed3506606"
    sha256 cellar: :any_skip_relocation, big_sur:       "e7311e69c72b825ac5c952114f71d17518f5b1d9576fc781bea3fb4f5ff8b15f"
    sha256 cellar: :any_skip_relocation, catalina:      "7911fb5b990b978621e56c5d3ed4cbad479dddd2f9771c10f2f51ff39d801cb2"
    sha256 cellar: :any_skip_relocation, mojave:        "9232d56bf94c52d3b703f8b225fef0812af9f76d47bd2d8a65a9e9248e7d9b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "413b0f6d4f14c89adf6c33bf9fa625ef10605dfc675bfbc476a199d4c8d8a087" # linuxbrew-core
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
