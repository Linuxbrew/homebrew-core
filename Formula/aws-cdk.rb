require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.95.1.tgz"
  sha256 "8fdf6d16651578408c38944a0d7c7680156068c5af2d4e5cb2e04681182b5977"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2aa470e84ebb8262ac8906751e8394eb5d28295e8b5f06ca1d2832e6c752ff0"
    sha256 cellar: :any_skip_relocation, big_sur:       "42118251f2a8978d07998ab56660d05557b8dde8c454a2eb6958cb3235577383"
    sha256 cellar: :any_skip_relocation, catalina:      "e3cba6afb4fb02d2653689c8cfc11f027af492e447f272104e0eeda782b9ab28"
    sha256 cellar: :any_skip_relocation, mojave:        "d29f91a28d5b5094c915b7e867d5e12ce5070d627956c42a59a9439b7e0bb612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea8a47b59ae24c82990e8507a117df32659410206fbe2f74bb0dd50d6c34e0b8"
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
