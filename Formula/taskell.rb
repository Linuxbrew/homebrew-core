# taskell: Build a bottle for Linux
require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.1.tar.gz"
  sha256 "0c0d3e69390a6da10bf9050b03ac1319eb960e6afb25db39b4e33e33440f7db4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f54b52233d7843b4d2f4ce6c2187a266bbc78129c31968054c97c3dde25a087d" => :catalina
    sha256 "3b088dbd935d07efecc919ea0a6154c5f1c146e7c8ed23569f32d7351af35067" => :mojave
    sha256 "49078ae4e663deac24cef2b5d780d44535b131145695f82cc4b1f05e9e8a4e4c" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}/taskell -i test.md")
  end
end
