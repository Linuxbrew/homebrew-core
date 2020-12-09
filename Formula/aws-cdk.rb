require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.76.0.tgz"
  sha256 "18dbba1aae1b0098d4d48c1f5486b0722c754b5de8c9dd7fc2a6b55b0e771a32"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2e983175f635e3acb3a3c3708813ca2dd4ba82114c50247aa373c7dae9c68a45" => :big_sur
    sha256 "b636d2654951c44e506ad1b3b94b25aebc2df9fa28b3a3c3738048f1fbad87ef" => :catalina
    sha256 "bc2d1f7d4e33f665e489ed54f31d3fbb26881e5f42eb739564a881e734af5f9a" => :mojave
    sha256 "2306b571ed55b1837c0d9bcb06300ccf44a415da87327ddf2e255d9ec2459466" => :x86_64_linux
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
