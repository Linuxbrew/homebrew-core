# convox: Build a bottle for Linux
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191211175055.tar.gz"
  sha256 "3af04e2d968e614519f1a4b0d2d88f20d7f157138ade3058aee9717178c80f62"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b7a09e6f70ffe4af25284a7b1f3f1b14e21622b08a8c538a9b2374a1df00411" => :catalina
    sha256 "bc2d3439ca589f2e02992834772286e7f4f2729edd7a29f9b1edab32f1e6e00f" => :mojave
    sha256 "0c6668183d1474aa5fa89c23a6e1639e3f249a9ad04288ea0da5f6f38b44de60" => :high_sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/convox/rack").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }
    cd buildpath/"src/github.com/convox/rack" do
      system buildpath/"bin/packr"
    end

    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
