require "language/node"

class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-1.99.0.tgz"
  sha256 "b9984bb8778a53163a878f77d8c7f131beca5dc244ecdd087859d7454e87c73b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "11971ce38217f9e9e581611006335cc97a4ca49a95ace8a34657cdd2d70f1979"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d98fa8aaab03047455a4dab5863d7bf07a92787555e9a540e250cfb1d071426"
    sha256 cellar: :any_skip_relocation, catalina:      "6d98fa8aaab03047455a4dab5863d7bf07a92787555e9a540e250cfb1d071426"
    sha256 cellar: :any_skip_relocation, mojave:        "45ffd592cfefabdc76bc3b1215eda3282cd69dbe99f0476d30faec385401ccc8"
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
