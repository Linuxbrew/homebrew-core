class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.16.tar.gz"
  sha256 "242852c7026c74ec870c84920d2dc094bdcd1863828a342b4ad79525bfd98bc8"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46d7030567d1ca12f1907b0523b07c2f5716dc491c83f3b0fa39d145c7ff66ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c49791a055f1294b006922a1bea1fe46476ffd7e2263b8a13cb9391238c23d4"
    sha256 cellar: :any_skip_relocation, catalina:      "32129b1b31fb341d9954b556c6e651a4ea9819a22d8d405bfb011f1ffea205e7"
    sha256 cellar: :any_skip_relocation, mojave:        "1eed89cf0b275833e117307577f845ec914b9d3dc223ffff3f31234182dec383"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66aa594230715d6871c08c50cb4edcf89a564a3bf32dd027aa1f4f344c988c6c"
  end

  depends_on "pandoc" => :build unless Hardware::CPU.arm?
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
    unless Hardware::CPU.arm?
      args = %w[
        --standalone
        --to=man
      ]
      system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
      man1.install "taskwarrior-tui.1"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
