# lerna: Build a bottle for Linux
require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-3.20.1.tgz"
  sha256 "23c3031a2b8943b6dcc96721d128c1f1f01a8a60087b7dc5506185661d678aa9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b1d7c2d558ad3e28c403d08067994d266a3d248d0f001a3ecb254dd6eb68348" => :catalina
    sha256 "ba394c7ce7021030bd3a675ead648ec11bcb2328ac1ebbca084ebb6e03b7efa9" => :mojave
    sha256 "b092a704f0621c2ccbb6457db5b9a6ed1d6603fce974564069475bf993d2d35f" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
