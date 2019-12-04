# contentful-cli: Build a bottle for Linux
require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.1.tgz"
  sha256 "92cdbff4d67265f92490224b45450fea475a04cdda796d072e0f05079c072f2e"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f098e43e67bea0f5c6615651f8e9ee9035b77d9d43b7965a408da96545ab9297" => :catalina
    sha256 "c0b8b2e3c74401016d593f6507fabdf6ad76e4cf44600451478acd8053e2dd41" => :mojave
    sha256 "bf72c13e10d50dcd4969a582a570603ce5f2134ec49a93f7477871d99cc38b24" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
