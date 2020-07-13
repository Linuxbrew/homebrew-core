class SpaceinvadersGo < Formula
  desc "Space Invaders in your terminal written in Go"
  homepage "https://github.com/asib/spaceinvaders"
  url "https://github.com/asib/spaceinvaders/archive/v1.2.tar.gz"
  sha256 "e5298c4c13ff42f5cb3bf3913818c5155cf6918fd757124920045485d7ab5b9e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "221c4d6f495ed8b4c1db5c737b4ff08be55a65b2bd15fc1c3e43ae96e29726ba" => :catalina
    sha256 "3f6f5106ba62445e33e2181facd9644dde99bb0f527455e4b49cecdb56cb56aa" => :mojave
    sha256 "5a512f039b4a9698eb5ce766798f462b134e98944e07ab3eccf712ee35c811d1" => :high_sierra
    sha256 "672db5956f42626d3e9fc18defe431c4f2c18cd647f8cd534f9f522c314a0c49" => :sierra
    sha256 "2ac0b623df41e8c9e9da05fc7f21e842bce1e71c0b9d4db52ef685cca9e040b0" => :el_capitan
    sha256 "99a7e2c353d5dbb310fa03e4a430d05e0092cb0aee1c19e38bd592492ae16487" => :yosemite
    sha256 "720fe6d4f6871b7f1aa5de6024806d00c9dee67a65cbcbf60be8c184cf0e55c9" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "mod", "init", "github.com/asib/spaceinvaders"
    system "go", "build"
    bin.install "spaceinvaders"
  end

  test do
    IO.popen("#{bin}/spaceinvaders", "r+") do |pipe|
      pipe.puts "q"
      pipe.close_write
      pipe.close
    end
  end
end
