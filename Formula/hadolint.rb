require "language/haskell"

class Hadolint < Formula
  include Language::Haskell::Cabal

  desc "Smarter Dockerfile linter to validate best practices"
  homepage "https://github.com/hadolint/hadolint"
  url "https://github.com/hadolint/hadolint/archive/v1.17.6.tar.gz"
  sha256 "c2de395107f33948f383a0670cf11bf5a54f9aacbf8eea568bae807adf45463e"

  bottle do
    cellar :any_skip_relocation
    sha256 "93f0d394892e8a508027e4d46e53c8df3b5e13c12d747a78ac8fd20e390a2fb6" => :catalina
    sha256 "6087ee380c2b66cc7b7c2cf926402077c5d2deac7333237eecb7a4c82286b8b2" => :mojave
    sha256 "397569db01cf56a8fa5693d70598d4bf48c361db11b3b51479a7887c7ed93cef" => :high_sierra
    sha256 "6ebfddc1d63f10ebe68e2b9eff1efa1e6045b059c01897c92cf1de9148c0dfb5" => :x86_64_linux
  end

  depends_on "haskell-stack" => :build
  uses_from_macos "xz"
  depends_on "gmp" unless OS.mac?

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
