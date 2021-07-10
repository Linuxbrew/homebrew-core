class Gitui < Formula
  desc "Blazing fast terminal-ui for git written in rust"
  homepage "https://github.com/extrawurst/gitui"
  url "https://github.com/extrawurst/gitui/archive/v0.16.1.tar.gz"
  sha256 "84fd4c1c004301a12b8f96f3f9218cda5a1263e8bab8480d3857553562a057f2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c54ed7fedaa443b6969acf534ac5394d8f88a81bec4c6752c713a5c150f42e67"
    sha256 cellar: :any_skip_relocation, big_sur:       "4640d62f90ed33ee842222cf7097107df01859e8ef6ca3f73d9d9dc3e867657f"
    sha256 cellar: :any_skip_relocation, catalina:      "3d6c1149eac1794de3968fd9b453b60ed3320e3b95ef76e52538abc61e7f9049"
    sha256 cellar: :any_skip_relocation, mojave:        "13fc418071d3171cb4351caf40a1e90157aae83fc0bddbb3a68393ba5964447f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e82bec297b03262bc060c04c4230cb4986890f8aec051f8b74b0bc55e5959b98" # linuxbrew-core
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
