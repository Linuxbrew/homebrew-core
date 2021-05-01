class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/terraform-linters/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.28.0.tar.gz"
  sha256 "bc80aac540bad91e1b239796854e200c4f2a19585874d5c4ce9c4de7dad5a81a"
  license "MPL-2.0"
  head "https://github.com/terraform-linters/tflint.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1b445c37a0e0c29b8b833e7e99ef0399210d0e7bba1cb981d440f6c0360f4f97"
    sha256 cellar: :any_skip_relocation, big_sur:       "5f2927d43a30ea2f29be82a89385d343b2b79e0cb553125e8b2b17362d82423c"
    sha256 cellar: :any_skip_relocation, catalina:      "8d0df88c776c44bcc34de56d0c85600c2a663d8f485aafc40e008eb4e4daefd1"
    sha256 cellar: :any_skip_relocation, mojave:        "8eee98091cc409c8179d44dddd500f025058789ddb78b8f2bd0f156f783e9ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8afabb19e712aaaa3d19edb88b46026b299a32fa0216bcad5db021a12d9be53c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
