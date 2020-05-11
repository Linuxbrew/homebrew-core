require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.38.0.tgz"
  sha256 "090df9e364b6cb56c0fbe7b696fbb298c162add7a547ae2f35a4a635f2c4b7f9"

  bottle do
    cellar :any_skip_relocation
    sha256 "349b1f0a86fe0fec9cfe763ba0e6d4af507ee76c79cad612fcdc1e7005c57a31" => :catalina
    sha256 "1a43d27dd9f0afe5114a6531bf82604723b4c740aefd006766062c8933413f30" => :mojave
    sha256 "b8a4fc74e05e771c14c40adb6b5cdb7d1256b88fa4e7e2c322198698c4175cc3" => :high_sierra
    sha256 "0eec3f970822773bbf408e1dbf3eb7cf2493474ce799f337c3d4c2a0a61db9aa" => :x86_64_linux
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
