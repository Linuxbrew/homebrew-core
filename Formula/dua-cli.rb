class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://github.com/Byron/dua-cli/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "4eee5384a543c8b33e88438e5364ce063a41ea22f695366fcebc747cb9fee3e2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f5c81c427cef05799ff50cf78e5b14b69127ce28499ed8fc3ee781bf21c502e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "4ebd0d05823dce7a0ec402fd55f019a318806eef3141ecad91aa636bf04b8685"
    sha256 cellar: :any_skip_relocation, catalina:      "db40235f5619a476e14e14bdf04fc6f3874e9d6c8844c5b5cde8adf625b208c3"
    sha256 cellar: :any_skip_relocation, mojave:        "439fc5d8bd3b51ee1a85cd8d56e4c71a2eacbc087ba5c171b54297a4a60564fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13267424bcc7a8542e2d4f7e9bc4ee551b0719e0d33a8849c174b3a867d3ce7a" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    # The "-EOS" is needed instead of "~EOS" in order to keep
    # the expected indentation at the start of each line.
    expected = <<-EOS
      0  B #{testpath}/empty.txt
      2  B #{testpath}/file.txt
      2  B total
    EOS

    assert_equal expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end
