# convox: Build a bottle for Linux
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191113121154.tar.gz"
  sha256 "c440cc8cd8c7c3fbf547d00f43d5331434f4968165067e5b1d44457f2b10f05c"

  bottle do
    cellar :any_skip_relocation
    sha256 "31534e263a2e241f2d35d3929e1ec04defe5975d15da1346514d12884423afb9" => :catalina
    sha256 "3bc4105d38b3d597323c0eb51d6ac0fbfad35086f89efdee7c16d4f27a0e8a84" => :mojave
    sha256 "9ae9f5a2bc7caebb7c965599431080e6376f03e48d7f1366d09e7bb68e9c5452" => :high_sierra
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
