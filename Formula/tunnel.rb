# tunnel: Build a bottle for Linux
class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.5.tar.gz"
  sha256 "b61b0adff29652e43cb32f14a11938b270c1eb3845d3ab78bdb4c7c63ad48367"

  bottle do
    cellar :any_skip_relocation
    sha256 "03b147c835823581a8ff6c809bdde796577563262cd335ea026ebe9fb0742f57" => :catalina
    sha256 "a49851a9f170bb50f6c6d5537f97895d32de8e971421c389a638e1f7fa84b3b8" => :mojave
    sha256 "3ad24e641443691321347d98ff4d2aa2ff097cd7140458f3abf4db6217243770" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
