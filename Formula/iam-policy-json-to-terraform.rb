class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.8.0.tar.gz"
  sha256 "428ee4c7c40a77c3f2c08f1ea5b5ac145db684bba038ab113848e1697ef906dc"
  license "Apache-2.0"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ac00a7ac5a6ff93c27f096a6a8ff9e77cfbe65a18825f4d70411b0dfd93c64ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
    sha256 cellar: :any_skip_relocation, catalina:      "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
    sha256 cellar: :any_skip_relocation, mojave:        "414adbbf759816cf41a250c66cf375e85d0d4e03d94cdb6b41aba59000f72b87"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = shell_output("echo '#{test_input}' | #{bin}/iam-policy-json-to-terraform")
    assert_match "ec2:Describe*", output
  end
end
