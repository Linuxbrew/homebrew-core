# broot: Build a bottle for Linux
class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.12.1.tar.gz"
  sha256 "e2036165dce4a8e77a2e6d1ec5c8f4c2bd63027734b1e660d3cf6685179f5846"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c5c86dfad2b3366fe19183e9f07f21da6b7f8f673021aee0e1f72f45bcfd0d9" => :catalina
    sha256 "e591afd42fe2ca6648809964fefa303b323a9b77f36f5055fc7015e59c65697d" => :mojave
    sha256 "81f8417222d607159d2ca31f453ada1aa51088dcde128aa534fcfe9772b88551" => :high_sierra
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
