class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.4.0.tar.gz"
  sha256 "896c4ab205a3ba152493747b95340cd46e94063ace4bd587dc6be55fe8303386"
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "866b6a7f09bf2b283a26f4fa59aee835820a3386c07b52002cd8a7bd992bdb0e" => :catalina
    sha256 "83247360c923d59d52738b536cb12f8ca0d0cf108e19fb5eb8433163c3e73d6f" => :mojave
    sha256 "2d488e59a5fc1d50746e3d9e690e212e20ea82700a6bd6d9245dfef007544f35" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"

    dir = buildpath/"src/github.com/flosell/iam-policy-json-to-terraform"
    dir.install buildpath.children
    cd "src/github.com/flosell/iam-policy-json-to-terraform" do
      # system "go", "build", "-o", "iam-policy-json-to-terraform", "*.go"
      system "make", "iam-policy-json-to-terraform_darwin"
      mv "iam-policy-json-to-terraform_darwin", "iam-policy-json-to-terraform"
      bin.install "iam-policy-json-to-terraform"
      prefix.install_metafiles
    end
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
