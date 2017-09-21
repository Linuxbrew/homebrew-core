# convox: Build a bottle for Linuxbrew
class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170918191932.tar.gz"
  sha256 "f3bbcc8c8fc73dc84787019464cf02eb5e07cb52a6db903e3ee7b4ca78097f09"

  bottle do
    cellar :any_skip_relocation
    sha256 "77036dca71fa71c6c7095fab82fc6efb2346c24ffaaa6fc759d6d9bc5a403e82" => :sierra
    sha256 "6a7cd8963e56d6d648f347aa9ceafaaf90463e03948b9bcbdec6e4e6a419357b" => :el_capitan
    sha256 "72670b32fc060c871449af90daed7323128005324f5295aea0aae97aefc879c7" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
