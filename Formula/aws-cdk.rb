require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.51.0.tgz"
  sha256 "86cec8fea76f159f878d4575f4b28c3b644724c3d519ce27df2fcd2d1f378e61"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "2228c8c8ec23b06c11c093f7e15609082e91cda9b738900cd752913c91788fe9" => :catalina
    sha256 "e8822a85b7c893a6c102c5b32c8f5f13a8277c8917623ea207ed30fe14c21c84" => :mojave
    sha256 "f1751887c9ec71c19e73ad2a0027bab84df32fc9b71906c50554dfa8cf8b84ee" => :high_sierra
    sha256 "774224cfc2f3de2b393485f18964139a414734a6d8e938f84b921e4d62b8a8ac" => :x86_64_linux
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
