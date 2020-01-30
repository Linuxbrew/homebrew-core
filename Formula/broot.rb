# broot: Build a bottle for Linux
class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.12.2.tar.gz"
  sha256 "9bba901cb81332e5b120e3bdd2d5445386b61e8a6312eebd48204b4dc03a27e7"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "12e0e5c310f9cbbd086ffcf94cf97c3ea762065a2af92929180a48f5dfffa460" => :catalina
    sha256 "9bbc9d52b3cdb6d3d75d0a78018a8d10e5f3a995db26162bde5cb39fd40b1c38" => :mojave
    sha256 "a17dab47f6303cd998f0616557f31d411558a5e93da821af79dfe79b34a33cee" => :high_sierra
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
