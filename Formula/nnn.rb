class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.3.tar.gz"
  sha256 "16b245cf984d81a7e35f1a6a6f52bede4810784f06074d69369f664efdf32aca"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "0974658c7c0315c30083f3db92cc37b34bbc2600c4b80392c6fa0124eb96509a" => :catalina
    sha256 "0fb61b265b7f5a99ce30b930141531b55d789959de46d625b209c2238529df33" => :mojave
    sha256 "5c04648426900cf44dbf1207f0fd36f8a003e30a6362a6606ae7a9bb58a495b0" => :high_sierra
    sha256 "c7f53a67e550622ebf91ea529a9835ef7634e41ca4367e302242ed216b3f5268" => :x86_64_linux
  end

  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if !OS.mac? && ENV["CI"]

    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
