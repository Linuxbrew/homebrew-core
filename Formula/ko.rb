class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.8.2.tar.gz"
  sha256 "ba4cff07c78b131de7b28c5bc7d6dcf1f6eb8a3bf7dbe5c4e249f5c4212bda4d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f4002186fc347777aa33b93cc15e2789c42c4633f3dc3c9b79bfa7cd127961c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "4fb84c226a9be21f6d1e74fe2a9623b9e5359d7e224f5d6fa252d6615d6f3014"
    sha256 cellar: :any_skip_relocation, catalina:      "18ead79305ac4da43e9135168178038e185723688380634104d73014913cfc77"
    sha256 cellar: :any_skip_relocation, mojave:        "fc632167d22a5aabed09e3dd551fb2b8533c262d8b5f7274952db4d6dda423f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a91a4f7ae1684953d7f0954dc3a6815d7dc2e8528f96e2d5e25d733b6771adf3"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}"
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output

    ENV["KO_DOCKER_REPO"] = "ko.local"
    output = shell_output("#{bin}/ko run github.com/mattmoor/examples/http/cmd/helloworld 2>&1", 1)
    assert_match "failed to publish images", output
  end
end
