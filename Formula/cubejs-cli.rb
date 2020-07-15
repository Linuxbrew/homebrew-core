require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.19.48.tgz"
  sha256 "94ccb156e453cbdbab0dca83ce0870cb41ac35d5b5d971846c565bc3a7b25eca"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "28956e5b0af37c95adea0dea763486bd616824bc279a4dc285c0b9eedea29c60" => :catalina
    sha256 "024a14d3785b779ddef050f5f1fa8b1deddce9717647957f89d62c49042022aa" => :mojave
    sha256 "bf23e7ee8d73238b3d6c2edd3a7cfecbe3e5b32426748debf12f36741269edaf" => :high_sierra
    sha256 "c868d3a7e54d487df847954b977e78bf9e1479e650c675afdae1cf6616412434" => :x86_64_linux
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
