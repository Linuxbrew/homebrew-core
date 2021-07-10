class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.2.2.tar.gz"
  sha256 "151e5ce32403f65892b0a15df04310ee4d115e12da9d38a7289f13f20e753d92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "51f4bbda8d5d2ebbb7c0f0a77d8c2c04c7ec9640046b07f67c573e74c1e49861" # linuxbrew-core
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
