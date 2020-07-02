require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.47.1.tgz"
  sha256 "0e407dcdeea0d90111af69f4e132f706495193d1aff8b171d3d329dc66b73cc0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d2f7cb20724118443f62dacfaf01e823ea0519b32916d1875ddb78370777fc3" => :catalina
    sha256 "57bb09b8cab78eb4ba4f8cea26f19f5de75a06c7d73d0a1c2cd30718a92eee5b" => :mojave
    sha256 "f421900eb939b2e0c592e7c41265ffc4066fa7c9c8ef8f8a4971114828ec2764" => :high_sierra
    sha256 "fd1ac01ff3df989328007f366b62d973d75fc8f045161a680db28ed5bbd7e9a3" => :x86_64_linux
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
