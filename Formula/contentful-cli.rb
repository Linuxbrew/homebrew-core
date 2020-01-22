# contentful-cli: Build a bottle for Linux
require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.2.10.tgz"
  sha256 "ca1d19f783c464ed866cf9a081fac5783f11d6486eebeea001a2c64dae34b2a7"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df5249043a6f99c7a972b0b85aa1b6a340eb4b38263624a6b006dac8ac9b0e36" => :catalina
    sha256 "644c3c6bf463bd9eafcc342f5d19e50a9c7872e8a530aa7a20aa25b252254d4c" => :mojave
    sha256 "77a8917df2786626c8d4d8b675ffc3af72be2985e557a2dfe349c56eccc39b09" => :high_sierra
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
