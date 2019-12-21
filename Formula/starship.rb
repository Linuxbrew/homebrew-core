# starship: Build a bottle for Linux
class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.32.1.tar.gz"
  sha256 "f5c16becf2fbfb0a9a6d47ded655db2be2d8cb0b5e5f7899b8e23c5e2d356810"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1a720c62ddc724ec1907541c883e19001f00ef3df3ee90636698f2e333573a6" => :catalina
    sha256 "f4fd53fc452556ffc9fb31dc159948e3777912396c7d34a1797896b705351a3a" => :mojave
    sha256 "8e0807cb1feb61d73c6519d44b95c4839d03d316d246b721a76d674130f97d76" => :high_sierra
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
