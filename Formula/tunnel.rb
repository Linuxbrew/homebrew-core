# tunnel: Build a bottle for Linux
class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.2.tar.gz"
  sha256 "fad292de938197add428df9d8d888be74646c323e9856a3fee86a6c70a94b2c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "550e9b1fa482bf8277696ab8f4f036749235310fab0626f7bcfb82efe13f4c91" => :catalina
    sha256 "130a866ef498c75b71a302ea6917f734cea7a68eccb87133deabd2f6122e48bd" => :mojave
    sha256 "3ae0daf4bfd4e4461146bb5cfeca28ada68ad9657db9519dc27710b4f51956f8" => :high_sierra
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
