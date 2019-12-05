# git-delta: Build a bottle for Linux
class GitDelta < Formula
  desc "Syntax-highlighting pager for git"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.0.14.tar.gz"
  sha256 "777b90bb20c89b63eb158d238dfb38914c3bc4617d65f8a0e465227f9c6884f9"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9bdeb7ae70e15518ddec6bfd1e70c6607fedb58fca17bef9d468805335511dbe" => :catalina
    sha256 "d1cdedbc8bf00651cba4593fa445709e276112a16fd1ed4017e8059f80badd44" => :mojave
    sha256 "4f6eb763466198d79b5a3289de64992be835ed75d40615a64f6c8e98cd600471" => :high_sierra
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
