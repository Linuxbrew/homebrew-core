class Lsix < Formula
  desc "Shows thumbnails in terminal using sixel graphics"
  homepage "https://github.com/hackerb9/lsix"
  url "https://github.com/hackerb9/lsix/archive/1.7.4.tar.gz"
  sha256 "6079d0b46e4d56cd0a16f31c9f9fd13da2717cdb990033daa820534b6dc4034e"
  license "GPL-3.0-only"

  depends_on "bash"
  depends_on "imagemagick"

  def install
    bin.install "lsix"
  end

  test do
    output = shell_output "#{bin}/lsix 2>&1"
    assert_match "Error: Your terminal does not report having sixel graphics support.", output
  end
end
