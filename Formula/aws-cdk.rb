require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.50.0.tgz"
  sha256 "8fd8e8c30b45e2e2f00b0e855f0381d8320bcfa347d7800bce81fa215d97ae55"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a0e02e8242cb77e0c3e1a7cddbe6806d8f8fe7bcb2e8b5f378828e2504f361f" => :catalina
    sha256 "a389abe0ae35d3f63179e62c571ccbb71c5588eadc6a553af40ecd4c56a0a316" => :mojave
    sha256 "583db8c46dc5ccb41f5d5091a661437a065336ef6696136b2a92d9b417142419" => :high_sierra
    sha256 "3d27bed9aa0519405ca8e49e7c5ac2947a4c49ea4b430f6b2493cf118e30836d" => :x86_64_linux
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
