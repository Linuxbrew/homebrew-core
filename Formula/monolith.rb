# monolith: Build a bottle for Linux
class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.0.16.tar.gz"
  sha256 "b2f5cd1d95d4d2ccd06e7f44e88e43ff0f2ec5d73dabe93ca56bf22656b06a0e"

  bottle do
    cellar :any_skip_relocation
    sha256 "e999c699c71652b99e8b9815c465979f762f8c73a76331130551ebf92e4f658c" => :catalina
    sha256 "8a5fb488b300e28d29691bffb530c29d2a45c12dd44c228d24d86d3d7d473b5a" => :mojave
    sha256 "589877c03351b3dd89555cc3463c0f5e4339732d0ab7fbe8fb8d346826256326" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
