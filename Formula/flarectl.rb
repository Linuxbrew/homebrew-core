class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.11.7.tar.gz"
  sha256 "d35d07833cb61d290750882c083c16a77860eb4615c5e14d3315f21a200f4662"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "263f404a08fc223ebb4c540ef788674760072c92fb6297f20572681ba8306a31" => :catalina
    sha256 "72823f606afafa9c37ba7499dca4c1167e50411f46a51d60f97574e894bc0894" => :mojave
    sha256 "3e41c3f80638f768b61f0d9447851ca3231cd2a1ae93d7afa5f205ca64c41db3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/flarectl"
    system "go", "build", *std_go_args, "-ldflags", "-s -w", "./..."
    prefix.install_metafiles
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid format for Authorization header", shell_output("#{bin}/flarectl u i")
  end
end
