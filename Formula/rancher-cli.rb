class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v2.4.3.tar.gz"
  sha256 "9e35b653f472aead86fbbd37bde6f3f311fa4f808d4230f091e18fcd4f7fd9ba"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb1c9bbde2479be996ffa2a0dd612a3b63868f31601e13f31e2f98504f970f40" => :catalina
    sha256 "517cfcd12c3676765052d8ca9633d631f55d9e006f5fd0c6721d108ac76c607e" => :mojave
    sha256 "cb1bf440ddc1852dd9d25ea69c90d2978e179e7a27aa6b840b65f33db397f143" => :high_sierra
    sha256 "2c6b6850b13cdd42b04b36a2e94e53126c594852bc067adae7b2226a5a97a07c" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
