class Xplr < Formula
  desc "Hackable, minimal, fast TUI file explorer"
  homepage "https://github.com/sayanarijit/xplr"
  url "https://github.com/sayanarijit/xplr/archive/v0.5.9.tar.gz"
  sha256 "03a628339fc8753b2d63533eca8749c0392f09063101c6d3317482500c5860ab"
  license "MIT"
  head "https://github.com/sayanarijit/xplr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bd40f3c968b350a7bfc923129b61377c11a8d885dce8bbf2c51606533cec5fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "90eca79c85b0d69bf26632f92c9a569aec8a75def4745284ae4b93253761dc82"
    sha256 cellar: :any_skip_relocation, catalina:      "d9d66845b596d0a393e1dfded5e021a94ef7f6eed6c5b46733ef6ed8be4545d6"
    sha256 cellar: :any_skip_relocation, mojave:        "76772163a2c74cc3da28e323fe16e70aee9156084b66140fba46432505475534"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input, = Open3.popen2 "SHELL=/bin/sh script -q output.txt"
    input.puts "stty rows 80 cols 130"
    input.puts "#{bin}/xplr"
    input.putc "q"
    input.puts "exit"

    sleep 5
    File.open(testpath/"output.txt", "r:ISO-8859-7") do |f|
      contents = f.read
      assert_match testpath.to_s, contents
    end
  end
end
