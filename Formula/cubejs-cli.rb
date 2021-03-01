require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.39.tgz"
  sha256 "3667b6dc68b1b817569b11e245520c830343f96b56110e127a4921d9347746cb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "54359121f5f06b3658302b57507fc828d881cc9e04be1d6c40c95610592f9343"
    sha256 cellar: :any_skip_relocation, big_sur:       "8499a3a827ef3506096a257d5991ed6c8e38a87f8b99aa778c3a938ed5749e09"
    sha256 cellar: :any_skip_relocation, catalina:      "67cc5f7898e5ffb61de266111ab7d5b167910c1c69b65d6dd92ee36d5cbdcd47"
    sha256 cellar: :any_skip_relocation, mojave:        "8b7d7eab97e3fa142ed91f936014a0d5885fbda8544aef432dad4fcfef5c495d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
