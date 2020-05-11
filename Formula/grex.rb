class Grex < Formula
  desc "Command-line tool for generating regular expressions"
  homepage "https://github.com/pemistahl/grex"
  url "https://github.com/pemistahl/grex/archive/v1.1.0.tar.gz"
  sha256 "52a9d5ddc15c7fb227c87147d991bfabe2aae1fbef8169893a9111dcd3aa641f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6a2e903b81404d8637492fdbdea4bd2bafc5b9e2ead89e565ed64ca27a8a9ad" => :catalina
    sha256 "add77eeff9facb30f56b579ab893bcfafcae43699e629b3780f67b560fb59ad2" => :mojave
    sha256 "b09e46aabadbb7742e60b942386f994795fcfca48a2834b2dbc4bc7fdb500dcc" => :high_sierra
    sha256 "34b7c6ababdee02dffd512e5354a7fb3de93c76866ad158e4477867ba3898ce6" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/grex a b c")
    assert_match "^[a-c]$\n", output
  end
end
