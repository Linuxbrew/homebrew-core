require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.36.tgz"
  sha256 "5632526ba7d85fa6ec484a5faa616969a66859b9ed5be097c25efdd51e950901"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "913b6b7a109aeaa2e6bf143472c52e4a1dbc7d0c51312565df77603a9b266feb"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac7d22b150499e6610685bdb91f7737d3ed5914c8adc7db589ce19fa01edd829"
    sha256 cellar: :any_skip_relocation, catalina:      "c2ce88b2fbf0cf64b26cdda2942be3a835b4ba15debf38f5a24048ed0b44058a"
    sha256 cellar: :any_skip_relocation, mojave:        "7b26abe30f7441f7ff5e564e3434f9e24e954592c19d6fc5c7f9c11a62396b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2d7a622815bdf9c07fdeff94d14be8cb4c8f2947e818332b143d1cceb7d94e"
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
