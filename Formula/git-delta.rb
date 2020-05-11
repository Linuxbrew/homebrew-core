class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.1.1.tar.gz"
  sha256 "50519e97310b54ddb485635ac8e0984670d4ae64fc7fd4a5ed2b67cc6b77347f"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2c934142464323e5b0061b633f964acd0fe3b9f87787693c086e3109c24cf4dc" => :catalina
    sha256 "da93a1dd32a32cf39ef98baedabcc83f041bdb7b0d4721e5304b175dacea4b10" => :mojave
    sha256 "9c88edbe0c662fcd99c16789c0de39d25e5537edb74cff26f1929785fb7b70fd" => :high_sierra
    sha256 "fc3382227be1dcc77327294d7e2b0796fa190e0b6a31d97e0f355fb19fce5e8e" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "llvm" => :build unless OS.mac?

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
