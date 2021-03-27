require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.1.0.tgz"
  sha256 "700b5ba49d5506a96f057934c3c55dbebba7543bb9a4c8e6d0d021a5e0aeb3eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99d3d9d4828377d514ccfa3199abf7f57c8d6eb63515dbb49a3a5f58dac8a344"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ab46301c972b35376f70371a9346967e228a2c37aa028d251a959221fb91eae"
    sha256 cellar: :any_skip_relocation, catalina:      "9f182925a38ebd2fddd45391f9999fcd03ca637608bf3b2e4518f36148479fee"
    sha256 cellar: :any_skip_relocation, mojave:        "cd1cc156c204945f5b20aba8e91f4d5b3c23a678b3eda11bdbd66baba69756a5"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
