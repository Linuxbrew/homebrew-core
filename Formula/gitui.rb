class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.15.0.tar.gz"
  sha256 "19476b4be4d383e316cc533f003a612f6d10caabda7ba757cfb3327b4210f923"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3d50103b6ee31fe0adbb2fec8e3b618f0929c9df41671fb3c2ead438a750de75"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2a1d2fc613bfc00eb3d4e23cf64c9c877995ed3b37895de4b0bb30a66db2d4c"
    sha256 cellar: :any_skip_relocation, catalina:      "0dde0cdbb92472ec0f77226c868f0584c9f4bbb37f6b64c7858a88321aa12197"
    sha256 cellar: :any_skip_relocation, mojave:        "b854ed73adc6a072c55fa794188560e27fde7e9bd89502cdd02312a53e6ba771"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7512a37e1822af6f7b7c264bbb0e64234f6434ee94dafe67e43cf3d4e40f394"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "clone", "https://github.com/extrawurst/gitui.git"
    (testpath/"gitui").cd { system "git", "checkout", "v0.7.0" }

    input, _, wait_thr = Open3.popen2 "script -q screenlog.ansi"
    input.puts "stty rows 80 cols 130"
    input.puts "env LC_CTYPE=en_US.UTF-8 LANG=en_US.UTF-8 TERM=xterm #{bin}/gitui -d gitui"
    sleep 1
    # select log tab
    input.puts "2"
    sleep 1
    # inspect commit (return + right arrow key)
    input.puts "\r"
    sleep 1
    input.puts "\e[C"
    sleep 1
    input.close

    screenlog = (testpath/"screenlog.ansi").read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")
    assert_match "Author: Stephan Dilly", screenlog
    assert_match "Date: 2020-06-15", screenlog
    assert_match "Sha: 9c2a31846c417d8775a346ceaf38e77b710d3aab", screenlog
  ensure
    Process.kill("TERM", wait_thr.pid)
  end
end
