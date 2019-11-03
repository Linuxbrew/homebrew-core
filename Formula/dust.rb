# dust: Build a bottle for Linux
class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.3.1.tar.gz"
  sha256 "a10e0b2bc5862928a257e05866e077866193cc673d97a711ddd63eeecd075867"
  head "https://github.com/bootandy/dust.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3b49364aa67239151c5cf3f133a3fe8f06ad06e8e625545605dba09c1da654f0" => :catalina
    sha256 "3a5a22375b9dc464a23226667bc4c4e0d3711ceef4ac691fb3de2fd96fa17521" => :mojave
    sha256 "f0abd07b12a44556813165f4a5266fad616dd62dce055fd4258205751aff2285" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
