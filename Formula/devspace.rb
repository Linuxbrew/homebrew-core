class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
      tag:      "v5.7.1",
      revision: "7ba03fa139f02840cb7561f57e045709823dcc0d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5083e1dccf6d49bcc07e5e0afcc98f35e6f46584a300ffef6af3ecd0145e2ba4" => :big_sur
    sha256 "6d87de3c078ad26ceec7a5052228391e54317b09ba89d16109981434aa5bea61" => :catalina
    sha256 "aea427785b98630059d77139b5e0d4bb46ac4ce9542ce4e99db1f3da5ee97acf" => :mojave
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
