# gitmoji: Build a bottle for Linux
require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.0.1.tgz"
  sha256 "3dad45cb85a81a7f756d11897e6f7fe7089f92a7d44eb2de1acf75bf8c7166c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "a014215369dea69b8991ea887a8b23b8a33128a944c431166f225d3650110dac" => :catalina
    sha256 "9b7e013b15fde3b78f3ad99ab15033aee59771ba12f5216fd08483f9f38750b8" => :mojave
    sha256 "6d1ca7bcd6aa15c9c2ec76e35b5d66415c4dc39ade9156e261818e178ad2e768" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
