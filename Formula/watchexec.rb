class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.15.3.tar.gz"
  sha256 "b8c2c6f8a90fbb4ee99a2be95972565ae0bb03ee3e2f6d5561fed9680db8d81e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77a3abf645dd959ac3421d26aa4056386a50b1e4440b1a69c9ca1ce0f73d6a21"
    sha256 cellar: :any_skip_relocation, big_sur:       "e11ea49833ca78297ead67ae8ff32b2b8023f70d26b589b9070a0b17a5b78be7"
    sha256 cellar: :any_skip_relocation, catalina:      "9111fd6e09f1cd824bd0a8df22b756323d79278f2d7a2afb7533b9cf1899bc5f"
    sha256 cellar: :any_skip_relocation, mojave:        "a34fcc86ceaf575414defd3b8ed169f541f6b2e7335c96c8ff4d4323ba5f3e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d739493c01fbe2addcb0d996c020de6298aecfce99ef49bf4b3ef41a0a0118"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 5
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end
