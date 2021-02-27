require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.2.tgz"
  sha256 "1ac6b1466725f21819a96db267e1c72af320c4299a15b9b03c05d6f7af3bdd66"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "445cab301158ac9a58312acf3f45f0804126918f237cceb1cb8bfc86f9d3db9d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9f13a2b4dc98204ce0537235b8836103360736d49484da974f7af3c76b0f082"
    sha256 cellar: :any_skip_relocation, catalina:      "6a0d1b89460ae9a4daf921d54d7754dd70622374a9dfc8bd65c1b38b732acd50"
    sha256 cellar: :any_skip_relocation, mojave:        "c72b3bba7bbe590d398ee74b34b8d8920538b9a5de2b0e4b5185faf6cabdaab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cefc1e328b57f18638defc69ca1b5b7bf227f6c06e9509d6354a50f97855f722"
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
