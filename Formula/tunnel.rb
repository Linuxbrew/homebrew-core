# tunnel: Build a bottle for Linux
class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.12.tar.gz"
  sha256 "325f577ffccae54269289eb3134ff7b1cae2fb60a882108531e622de8f6e21de"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae64aa290bdccdec7bcd07d11b28639588a8988c3dbcff6fb42006afd7ed129" => :catalina
    sha256 "e46ad17077c5593342eccd07452953f35c96816c82df3972dcbeb2aad5d5645d" => :mojave
    sha256 "dc840f6f2cb5cc6736c0c3f82efe9f01fa030856040f393f57a1ed7fdf728ba6" => :high_sierra
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
