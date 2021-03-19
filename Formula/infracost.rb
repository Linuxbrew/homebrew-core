class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.8.2.tar.gz"
  sha256 "36445b40fbc82f8d8b35d5f8921e3e4bfd43614e347e36e6eb49b3c4ee565227"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2883cd6bc522512fcb18d717520580c778a0244759aac45b99de0a33452c554a"
    sha256 cellar: :any_skip_relocation, big_sur:       "dde71fc7ce37e0f4a6af1a67ecb84f9b3ba0794f0749d6a70406b682a1e2cf64"
    sha256 cellar: :any_skip_relocation, catalina:      "2cdfca003c9c8f1a79ced5ef9a30c6bfe9505817282ec29422a67e65ee100756"
    sha256 cellar: :any_skip_relocation, mojave:        "293e550dafc2d2a01d277dab671a3dfbfcea7b0c5fbc4ee5df68ffa9d25b116f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3545a89094319a431acf6f1b3618a725c3ee3eafeb8ecd4fc223191ac44c47e"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
