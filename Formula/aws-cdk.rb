require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.90.1.tgz"
  sha256 "8fcde9340841742157a82206d36d6bdcebd825234de543f89021c3dd554c7c0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee36af8b3e08ab66a5dac78cb236e9722c0ed53ec37fc36737245b4c58a82d7e"
    sha256 cellar: :any_skip_relocation, big_sur:       "e33ee89057d9d40e70e925f136d0d7364901a88f02c01d345659666676e2467d"
    sha256 cellar: :any_skip_relocation, catalina:      "8444d16a961e1e88cba605807b28f861605c1e1130b563b21001725b196ffc7f"
    sha256 cellar: :any_skip_relocation, mojave:        "bee67784a27b1bb29019af45fcee5773957c000738304d6ed93ff12fe0b15865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6cdcb3db41e3812c7589883ed79d7043c7fb61a99f491b8f1f3866d3f43bc4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
