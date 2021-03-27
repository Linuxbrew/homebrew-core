require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.6.tgz"
  sha256 "de5d8878afe49de63d152488cf5c08af28e12163a66fad8bbbf51f45c1e9f81f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "081fac4ba8f416c353b2f4f4d893e1caa35e30ddf696e44ee25a80461956a759"
    sha256 cellar: :any_skip_relocation, big_sur:       "df6299e75b052cbc06c894307b4c656345904ff9366f651e0be9689fc2b6e0cf"
    sha256 cellar: :any_skip_relocation, catalina:      "eadeb81ceab35c34e05f8e1990a78ffd278593d57ccf0968410e1581e5070d1d"
    sha256 cellar: :any_skip_relocation, mojave:        "228f8722e0ac300f56e12e1e3b9864f3a8dbefedb10af0e5238436871886a1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc1a5dfb1c10c66464799b5c1de511e3b56468044aaafa2289cc07f1efb9afd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
