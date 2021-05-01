class Tfsec < Formula
  desc "Static analysis powered security scanner for your terraform code"
  homepage "https://github.com/tfsec/tfsec"
  url "https://github.com/tfsec/tfsec/archive/v0.39.26.tar.gz"
  sha256 "06caee8a4214d62ebbebf76142f3c755ef3438eef7ea31ed409a339ac5f7f08c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "daaa3b490742bc0dcc52d4694d189fbf7fb15b180d2a122e4967d5377130c10d"
    sha256 cellar: :any_skip_relocation, big_sur:       "5b3041bb66ad87896e523d46b6114b2eb1590a4b87bbbb0534a3e27c08a8a695"
    sha256 cellar: :any_skip_relocation, catalina:      "303965e7ae202f72eea584dcf72b92c05a6ae7bb0d559efbb33c23b368f29f88"
    sha256 cellar: :any_skip_relocation, mojave:        "9b2ff3d935a0cb62fa97424b1671cad93c1acf8861621dfb3f131c8b41ece4fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa574a8f9c00a3cb714c8658d3c6fc2d2b492129d2f0cbeb030a41c478c38aa2"
  end

  depends_on "go" => :build

  def install
    system "scripts/install.sh", "v#{version}"
    bin.install "tfsec"
  end

  test do
    (testpath/"good/brew-validate.tf").write <<~EOS
      resource "aws_alb_listener" "my-alb-listener" {
        port     = "443"
        protocol = "HTTPS"
      }
    EOS
    (testpath/"bad/brew-validate.tf").write <<~EOS
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    refute_match("WARNING", good_output)
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1")
    assert_match "WARNING", bad_output
  end
end
