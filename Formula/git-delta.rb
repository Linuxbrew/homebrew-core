class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.3.0.tar.gz"
  sha256 "4ff8d5864306f130be8e0da3d8013bcc4ece082835d4cc5395775c669111ed77"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "21a53f197f28899fd2649ed9f685526eb6a4a9fe13819fdc3fa543d5858e04be" => :catalina
    sha256 "db7c9389bf569314917cc0d0e979baf034955fdc90ab77dd4faafb934a71dfca" => :mojave
    sha256 "7aec3f7a0ccd5ce2f7bcd753ba6539fe2b8489e53b6b372a1a7802df036fb47d" => :high_sierra
    sha256 "85ee9a56e7858741f498a9caf9fcf1e468d212af65eca88f202c7a4ffba417e3" => :x86_64_linux
  end

  depends_on "rust" => :build
  depends_on "llvm" => :build unless OS.mac?
  uses_from_macos "zlib"

  conflicts_with "delta", :because => "both install a `delta` binary"

  def install
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
