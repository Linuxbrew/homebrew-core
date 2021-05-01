require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.101.0.tgz"
  sha256 "775609194c81b46830e839178874d518993b85436704d92c56cae865c605dd20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1bc91a7e80088f2d62036e0f0878d85fe1fd9cb048d3456743bb297fc19ff793"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fc4764ba21d405626eed9b97fae995fbe40d50fc73e72ec733d75277fb63724"
    sha256 cellar: :any_skip_relocation, catalina:      "6fc4764ba21d405626eed9b97fae995fbe40d50fc73e72ec733d75277fb63724"
    sha256 cellar: :any_skip_relocation, mojave:        "6fc4764ba21d405626eed9b97fae995fbe40d50fc73e72ec733d75277fb63724"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54f3fe0a6c8024fd5255070664a84f6388f66b25864d683f13df1c1b690d94b6"
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
