require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.29.1.tgz"
  sha256 "0becb5a6e18b3cd7ba71f71cdda4a01e687db2b33f720b67454f0fe79f5f7d54"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3492d9076d38c703b10b0beb6bb123868c280d559b4eae76dbb230cd982d6b30" => :catalina
    sha256 "bb572e2a1cd7e0c08a1d68316b2782bb2cd5d4ed9509e718ea485d1c51eab6d7" => :mojave
    sha256 "689492fa4566d77f73b608ade328430e8a5d3ef81fcdb109f9d666656da2ab7e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Error: No schema provider was created", error_output
  end
end
