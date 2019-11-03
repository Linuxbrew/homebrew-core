# git-delta: Build a bottle for Linux
class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta.git",
    :tag     => "0.0.13",
    :revison => "c2360a90d75e2d574a5d89d3c608ee77748e6d37"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a9ee6648bba008253f5258a755824d7654160c216cc415f1e0bcf24337e5d936" => :catalina
    sha256 "cdbc6610c601419514a7dadaff05c47601ea5c1704aec54e6cceb00467b2a195" => :mojave
    sha256 "b486d9c5f1115d350ae265edc9e87de91135703a55a7c9263c314958ab0b5cac" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "llvm" => :build unless OS.mac?

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
