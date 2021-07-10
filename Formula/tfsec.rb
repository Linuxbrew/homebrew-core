class Tfsec < Formula
  desc "Static analysis security scanner for your terraform code"
  homepage "https://tfsec.dev/"
  url "https://github.com/tfsec/tfsec/archive/v0.45.3.tar.gz"
  sha256 "022c2e8ca678b721fb2a17e090080c7f30b273ce92f953f3ef719e151af8b2a6"
  license "MIT"
  head "https://github.com/tfsec/tfsec.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b47f36b5433fb5fcca48b57d9ee8ed8bfc11b2e768fb9f0a82426c5084052de"
    sha256 cellar: :any_skip_relocation, big_sur:       "6842a6dfd6247e05ffc0861c35df74cb7ca59c21382de920b5b16e9f7ea56583"
    sha256 cellar: :any_skip_relocation, catalina:      "398028d965b58c33d2ce50eb009c3798463c27bed705cfbc32d0348034873813"
    sha256 cellar: :any_skip_relocation, mojave:        "90b7c024b0fed88c67e45b3bcda77afe77e48eaab509e6f220bc9dd9427ea7c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "021a792dbd46bee7c7f97578840a8c1d2f5b511e7f060700dae01d35c9023eb7" # linuxbrew-core
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
      resource "aws_security_group_rule" "world" {
        description = "A security group triggering tfsec AWS006."
        type        = "ingress"
        cidr_blocks = ["0.0.0.0/0"]
      }
    EOS

    good_output = shell_output("#{bin}/tfsec #{testpath}/good")
    assert_match "No problems detected!", good_output
    bad_output = shell_output("#{bin}/tfsec #{testpath}/bad 2>&1", 1)
    assert_match "WARNING", bad_output
  end
end
