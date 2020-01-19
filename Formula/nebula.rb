# nebula: Build a bottle for Linux
class Nebula < Formula
  desc "Scalable overlay networking tool for connecting computers anywhere"
  homepage "https://github.com/slackhq/nebula"
  url "https://github.com/slackhq/nebula/archive/v1.1.0.tar.gz"
  sha256 "ff08ce10c202a047149397b172e2effaac7f213676e99bb01293b751e73a33fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ab56a03259d3eab9fce10c2480a6c4c1331008b8c5336ee91b7ea57910d3ccf" => :catalina
    sha256 "4455c6cfc00f3da5c546d5ba27e49bcbfb624eebf7700937e2d8d18b6d0186e8" => :mojave
    sha256 "1b3b0d8fecadaeb8f93ce0a4477c8cda027b45fea6c1dd3786573dedb1976411" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["BUILD_NUMBER"] = version
    system "make", "bin"
    bin.install "./nebula"
    bin.install "./nebula-cert"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/nebula-cert", "ca", "-name", "testorg"
    system "#{bin}/nebula-cert", "sign", "-name", "host", "-ip", "192.168.100.1/24"
    (testpath/"config.yml").write <<~EOS
      pki:
        ca: #{testpath}/ca.crt
        cert: #{testpath}/host.crt
        key: #{testpath}/host.key
    EOS
    system "#{bin}/nebula", "-test", "-config", "config.yml"
  end
end
