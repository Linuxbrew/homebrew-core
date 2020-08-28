require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.61.0.tgz"
  sha256 "99f914f242bb2c4980cc1f0c75e90a130a4180ab8643989ad42fa8c0ab87d77e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "553b72d14be32333379494f4183bc559cba6048c91e4cd661761640de1bd6c76" => :catalina
    sha256 "fc09d451caa8e68411cfe0e666f9327e5ba82d33de334847a946ee970b2f3904" => :mojave
    sha256 "5c01b20e8e457a30f0ab76ffc7be4f345bb01baa0ff4b28aa6ddd2a9a0ed40c3" => :high_sierra
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
