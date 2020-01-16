# broot: Build a bottle for Linux
class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.11.9.tar.gz"
  sha256 "61dcccf81d0bbd0bdfb2651136a2622b75514549f69e2f7f3d58b83acd73a549"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6dccab5f81fd14ad040ebe6623a2bf82df86ec2812f24b102a79de364defeb3" => :catalina
    sha256 "167fb4edc68e17aea721ff0af58c5584fc4094d63d55f20f51ff6e4e56f629f8" => :mojave
    sha256 "db76e7614619a987874bf7ef3683bf06ddc04dfc463ef651bc63c7306545b8c9" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/broot --version")

    assert_match "BFS", shell_output("#{bin}/broot --help 2>&1")

    return if !OS.mac? && ENV["CI"]

    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/broot --cmd :pt --no-style --out #{testpath}/output.txt
      send "n\r"
      expect {
        timeout { exit 1 }
        eof
      }
    EOS

    assert_match "New Configuration file written in", shell_output("expect -f test.exp 2>&1")
  end
end
