# starship: Build a bottle for Linux
class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.32.2.tar.gz"
  sha256 "ca8cbb2a34f38bf80839d3e9e26efc3c5009bc43aca040a03d0006a7c6f0845e"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e9d247d78a57623898e4ad47c06b34539580435bd6526fa23d0b757bab7bcf2" => :catalina
    sha256 "535d9b655b9d09ffb3c3db23ec101336a40da5245992fcfa56fa57d12e860ecf" => :mojave
    sha256 "5ee1b33f6b1077364b6f74968b58798ae2714eaa901893d8f1982a8d7f8a13b3" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
