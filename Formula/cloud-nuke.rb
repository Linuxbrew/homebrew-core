class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.3.0.tar.gz"
  sha256 "6a7e3d2ed1672eff9938ed4e943e2f82244a2582996d91f91f89c9f1acdac982"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f76e8a69980bbd4e69e67a86c3916366f01904d36fea27aeb759508dcae6f273"
    sha256 cellar: :any_skip_relocation, big_sur:       "a0400870b85adf0f55013979617dcc2baa4c22b421debd5e36b05e92e869c291"
    sha256 cellar: :any_skip_relocation, catalina:      "59727fe2acdcc1279cdf9cf676a4318b8a4a46d62048a4e14c9d16c843ab60db"
    sha256 cellar: :any_skip_relocation, mojave:        "989e94022e5e8f060b3894b6a971356e469cec2460ac62091540b9b5ab82882b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e500e122a2596ac420cf9f5822b5c9d5144e5f991b40deb0e1c08e60eca37f13" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Before you can use these tools, you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_REGION="<Your AWS Region>"
    EOS
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
