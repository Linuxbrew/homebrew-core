class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.0.8.tar.gz"
  sha256 "216f39359f14eb32f8c7d3eb708ef095c6918f76bee9d2cbfb1571449025b68c"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e6ffa8f3cc1d838cfce2e6725b8b864d4520cc6ae31387b4c6203463e1f911d" => :big_sur
    sha256 "d11e9877f6f068c2b2da32cf06f158146ba2fb31e4ffb1899b0a2793dc105586" => :catalina
    sha256 "54f4efe1988beef4f7fff76bb869d49389b2478f96b0e2632d3e07a623f0471e" => :mojave
    sha256 "5b7f463acec9bf9da5120b4b9e9ec9cf1a259dfe92255d3a1378c072c24f788a" => :x86_64_linux
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    return if !OS.mac? && ENV["CI"]

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
