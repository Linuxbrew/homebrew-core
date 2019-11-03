# starship: Build a bottle for Linux
class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.1.tar.gz"
  sha256 "d48e7865f8c2807ac06cadaa3599e1edc3b45b38c086b9bd3a61e118c401807b"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db5d539071a612ac7339cbf7a2bd56d6a6184021cb3e79cead1e8b6809232cc5" => :catalina
    sha256 "beed2b3586115e19c430e1900d046f6d026251e6fa6db8f7bc8e2abbd25768af" => :mojave
    sha256 "48180658b963ea431215a0f348e6434af7f3eb0d7a450c0862c3095564664595" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "zlib" unless OS.mac?

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
