require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.53.0.tgz"
  sha256 "a85eb5af8da4c73c6cdb056b00f11c7e0c02578f7c36242df34c905f7b9176b7"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a36b90358a13d681fcd6aca443fea8a95a32342438a7d0c1a8b1b52996e35e5" => :catalina
    sha256 "20e30b1c4c64ea88a0519ec01e2b54a1c9927478ef7fc53e54592d63aabff804" => :mojave
    sha256 "8fa227c3c321f088c24a8825393d7b1c51e94d1ea13071218d5617445ed7bcd9" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "testapp"
    cd testpath/"testapp"
    shell_output("#{bin}/cdk init app --language=javascript")
    list = shell_output("#{bin}/cdk list")
    cdkversion = shell_output("#{bin}/cdk --version")
    assert_match "TestappStack", list
    assert_match version.to_s, cdkversion
  end
end
