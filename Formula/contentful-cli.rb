require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.65.tgz"
  sha256 "1d614d0f43ab4122a76565958233e70d561f67d0a816fd30f480f4b45b74b0f1"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "52d04b4de50e1ffa46e1bbc697d8a10c150e7c0c870b5e1c4ee283e04fc1b348" => :big_sur
    sha256 "88dff418189d64e9e0aca3a9a5c200c421185bb13f308a56399a04e483de7ee0" => :catalina
    sha256 "b4578b5ed36a11ca7123571e1ae9004b4c33921bcbe8c8715c9860e17f437994" => :mojave
    sha256 "53aef796c071e97b6b48c5a6f7f234bee57ca84a8ce926323cd91f17b91afb36" => :x86_64_linux
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
    assert_match "Or provide a management token via --management-token argument", output
  end
end
