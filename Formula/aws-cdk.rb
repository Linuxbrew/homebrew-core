require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.111.0.tgz"
  sha256 "5d24fec2911af1aa5125f538a71167207ba63c651b640ca4745f3ec86b26f02f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9a47ddc95830ae9f2ed8b9adf3a61cf7db5c56550dd100a786becb89b334f835"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, catalina:      "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, mojave:        "e8c29668d9001dbd2efad55bf371589cf5073cae8a16978bd416c2a9f95431bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5aa2b4662223addd9fadde71044cad20c2446fa336d68d0c5f6651943fb22fb3" # linuxbrew-core
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
