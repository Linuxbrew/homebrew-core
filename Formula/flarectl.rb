class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.12.1.tar.gz"
  sha256 "86bb23d7c7fe1abe5d93a05aafb7be5083d199a0533efc4bf8182db5d18afc3a"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "003f6cbdd67d765959c26d423ae22bf0f6d86ee58171bb959ea0aab3db66ea2e" => :catalina
    sha256 "ab954f85cc6a415b64be431b73c5c745f7cc06fc32dee83528f9916afefd9a8e" => :mojave
    sha256 "cc940eab138fa6c13fa9b5074bbf2a8b42f91fdc73c02841a8ccbaa4dff9e3e5" => :high_sierra
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
