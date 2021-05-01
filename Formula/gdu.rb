class Gdu < Formula
  desc "Disk usage analyzer with console interface written in Go"
  homepage "https://github.com/dundee/gdu"
  url "https://github.com/dundee/gdu/archive/v4.11.1.tar.gz"
  sha256 "e5a7069bd147949392b1fb536a8b34fa527da5b3505ace8f56d6c890a9f34983"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bfbefcc1304392fd4aafdae199cc0534b87470431f7ad35e8833127ca21c5671"
    sha256 cellar: :any_skip_relocation, big_sur:       "6cec30724aaad547af0602b94c7ee8a7a3e0562d69a470c7cca8b42e15ff0039"
    sha256 cellar: :any_skip_relocation, catalina:      "58ee9125b9b0ff3b5ed9546f25e6f00de1f1962c261947ab2cd87b5d3a32b3c5"
    sha256 cellar: :any_skip_relocation, mojave:        "d7bc01e455499e5f9752b9ed0ef484b7b1a8f73cc10efa77692d359b878f815f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83e2db1e793a2509902c84712f09c9c0c9361f17d54c2d81cc902d086aeccc53"
  end

  depends_on "go" => :build

  conflicts_with "coreutils", because: "both install `gdu` binaries"

  def install
    time = Time.new
    user = Utils.safe_popen_read("id", "-u", "-n")

    ldflags = %W[
      -s -w
      -X 'github.com/dundee/gdu/v4/build.Version=v#{version}'
      -X 'github.com/dundee/gdu/v4/build.Time=#{time}'
      -X 'github.com/dundee/gdu/v4/build.User=#{user}'
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    mkdir_p testpath/"test_dir"
    (testpath/"test_dir"/"file1").write "hello"
    (testpath/"test_dir"/"file2").write "brew"

    assert_match version.to_s, shell_output("#{bin}/gdu -v")
    assert_match "colorized", shell_output("#{bin}/gdu --help 2>&1")
    assert_match "4.0 KiB file1", shell_output("#{bin}/gdu --non-interactive --no-progress #{testpath}/test_dir 2>&1")
  end
end
