class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "c1d02b5aae4c89a49d68001b11a9e99bf86b6a70b322c09c5d2f2b5549a484de"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "816bb1445ab640765659f895ee04e5a5495b412298ddb7cca87b0c005803087b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c2e4dd3cb5e3daa339407bb5c67c97b398fd5975b7b2c92348fe53c57527f26f"
    sha256 cellar: :any_skip_relocation, catalina:      "24ce6e57bddf1bdac4b48d457d82719a230afa83034acbdd1410c3096e60d560"
    sha256 cellar: :any_skip_relocation, mojave:        "b5908e8fa0399be075a721084ca61689f62836e437aac1d494ca00202e16e575"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args, "-o", bin/"rosa", "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Error creating AWS client", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
