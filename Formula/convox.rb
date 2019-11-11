# convox: Build a bottle for Linux
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191110173914.tar.gz"
  sha256 "53d4bdea3920f5619a65377f5933a17c74e8e228c6e91c9776c07892280089dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c75769616e0b2006b8e87bd1cd2e6845ad3ad26018f050bd9a1eb29b120752e" => :catalina
    sha256 "c55d8b72a60f998f3bfbb8f58ceb2049e401c0d5532379a0dd11484992c236fa" => :mojave
    sha256 "283ef60a4158ec701afcc4526c5a90d63aff0cc682cc337659c1c231bfb625e8" => :high_sierra
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
