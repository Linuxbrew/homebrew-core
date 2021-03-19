require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.94.1.tgz"
  sha256 "b8fd6422f834d8331665ed68e0e099375ff451c7a0f78e3eb23c1b85ce95ed28"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c40e09b8ed1f3bceeb721a2a26f2cff7290a0e4b9d7ec09e801e018c5af7da32"
    sha256 cellar: :any_skip_relocation, big_sur:       "77bdbbcaed22a503436fd60696820e0156aaebfd5d8911cac8de76fe096866a0"
    sha256 cellar: :any_skip_relocation, catalina:      "5fe8288b2bedf31568423b9f38c06345fef9c3bc3fec8d3834cc82fda6b16f90"
    sha256 cellar: :any_skip_relocation, mojave:        "46c527eae1f817ee996b0eda0ca40c4daf32914ce6c572e643d33d3eb5bbdc30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9fddafe8f5ab1efc1e3b8eeca0d19b619d171386491731f8b06b839b2e75bd"
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
