class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.9.1",
      revision: "5dd723d3c4a42f53837429fc8e3d083d06c0133e"
  license "Apache-2.0"
  head "https://github.com/devspace-cloud/devspace.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2051ec547819e3d574ce6f6794f7b2acbec5c3c0345c367bb0315a8c05613d15"
    sha256 cellar: :any_skip_relocation, big_sur:       "51d6c5a1dfc7be5206643142f744130765bab7f8262379cecce892e57ae9a30e"
    sha256 cellar: :any_skip_relocation, catalina:      "d8e169a6e1d9958099f99adae781614c839a5ee57de13be4325fb4764e2849dc"
    sha256 cellar: :any_skip_relocation, mojave:        "a5939defc912e7e2bc93437211e66b91e5aed5523183a0448b93fd1297ee6c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa7f50447b44a563cd740af249b06248abaa51bc4bfa8ba22c2f14cb53a3e5cf"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.version=#{version}
    ]
    system "go", "build", "-ldflags", ldflags.join(" "), *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
