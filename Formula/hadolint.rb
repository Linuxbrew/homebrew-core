class Hadolint < Formula
  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.23.0.tar.gz"
  sha256 "4de7041e2bd8d41e7067f84af34d9266f2b2955c78ada3065ba9ea88c6ba0c5a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "b1c8f84a503573878f54555eb078267fca55f264fda86623ced0978d802ea9f9"
    sha256 cellar: :any_skip_relocation, catalina:     "5e7a1bedb379a03f47feac56d9e618a92c2d7127c93d6f2c19fa3241ab8c438c"
    sha256 cellar: :any_skip_relocation, mojave:       "aa26d65c5fec4c688e6f313e0179547b2f0d96b289b28dbd7134a02d5ca33ba5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "67a444c2d77bef15e2d23b3517fd7de2f3015ee9f39bc2ab898aa818161531bc"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "xz"

  on_linux do
    depends_on "gmp"
  end

  def install
    unless OS.mac?
      gmp = Formula["gmp"]
      ENV.prepend_path "LD_LIBRARY_PATH", gmp.lib
      ENV.prepend_path "LIBRARY_PATH", gmp.lib
    end

    # Let `stack` handle its own parallelization
    jobs = ENV.make_jobs
    ENV.deparallelize

    system "stack", "-j#{jobs}", "build"
    system "stack", "-j#{jobs}", "--local-bin-path=#{bin}", "install"
  end

  test do
    df = testpath/"Dockerfile"
    df.write <<~EOS
      FROM debian
    EOS
    assert_match "DL3006", shell_output("#{bin}/hadolint #{df}", 1)
  end
end
