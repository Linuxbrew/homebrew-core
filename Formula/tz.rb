class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.4.tar.gz"
  sha256 "79764c29b66c2d5a158967e58ae0ca413f1af590b63920016ad7f0767f8c8494"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3b53e889b310602a755fab23839c9134c994ee02ea118df21fb81040a520d50d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a882631f9882b6c00f7882f19cbfb1fbb9fead69338b00be57a99a739eb14d6e"
    sha256 cellar: :any_skip_relocation, catalina:      "9fb0b941d372b44767aa8751effeb114a05b5a77b59898a66e57cc6edf19ec1f"
    sha256 cellar: :any_skip_relocation, mojave:        "390307fc57faca9a2b4caea72fefc55d1ae5e332cc880434d67be95e0ca4b6b5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    # Bubbletea-based apps are hard to test even under PTY.spawn (or via
    # expect) because they rely on vt100-like answerback support, such as
    # "<ESC>[6n" to report the cursor position.  For now we just run
    # the command for a second and see that it tried to send some ANSI out of it.
    require "pty"
    r, _, pid = PTY.spawn "#{bin}/tz"
    sleep 1
    Process.kill("TERM", pid)
    assert_match(/\e\[/, r.read)
  end
end
