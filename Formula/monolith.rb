class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.3.0.tar.gz"
  sha256 "21b90f9b047a98a4d442795d949952fe687ae14d75cc5f416f1cf77c53e40bca"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "a649875bbcc3d2fecffa1fa5cb9493145897130b1d4b56265d3fe838d76bd052" => :catalina
    sha256 "32a2ea3a355cd293597bf5e3ff8f90d22d78ffd5eca961d7b11d890bafbef10c" => :mojave
    sha256 "7b19c2cb961629047ab88c32dbc3752490f3bf87283838104334f812eaf3ae74" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
