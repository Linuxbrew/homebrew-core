class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer/archive/2020-04-20.tar.gz"
  sha256 "da47d24f24205c77bd8aeba4f0c2d6b7b12f2462ceab7e19473282c9946bd69c"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path",
           "crates/rust-analyzer", "--bin", "rust-analyzer"
  end

  test do
    system "#{bin}/rust-analyzer", "--version"
  end
end
