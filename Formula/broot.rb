class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.18.6.tar.gz"
  sha256 "b0ad7f172885639dc55cd1c94c606b1ac7439e3ccb5233cfa9e2ed04f3a3bbf1"
  license "MIT"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92666d82f36da8d887cbcea3c82f8df6d3ab7f0c61fabcbd8a00be836a5d4514" => :catalina
    sha256 "9765202dd69089a4637dbb385d1405dbf40d6da3dbfe9e24ce57e8340d9dad93" => :mojave
    sha256 "38ba81a8dbcad778c8bd61e82fdbf3a9c41117650b55840555cebae24b5bc5e3" => :high_sierra
    sha256 "386785ec4fcb7ebf2558c9c1a5d7dc405e79404bcf4bfdbd029f27e8a4168681" => :x86_64_linux
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
    PTY.spawn(bin/"broot", "--cmd", ":pt", "--no-style", "--out", testpath/"output.txt", :err => :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency termimad requires width > 2
      w.write "n\r"
      assert_match "New Configuration file written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
