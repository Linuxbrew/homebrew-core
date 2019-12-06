# now-cli: Build a bottle for Linux
require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-16.6.1.tgz"
  sha256 "0fe8b20eccfc855fea2e017171b4266edd863454cb09f6aa6fee1cf4e9330eb7"

  bottle do
    cellar :any_skip_relocation
    sha256 "10f66f09f3f8edcbb7d06a62a37c2cc166bc9b98bbd99058866b0e4214616a70" => :catalina
    sha256 "54ac2f38dec1cdfd5d2de1e7f8d917835499ff480a12ab4dc611298ac331392b" => :mojave
    sha256 "58cf06c353761e34e727fe32174c4ec59805bafa77627d544242d319dd35e44e" => :high_sierra
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "t.default=getUpdateCommand",
                               "t.default=async()=>'brew upgrade now-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/now", "init", "markdown"
    assert_predicate testpath/"markdown/now.json", :exist?, "now.json must exist"
    assert_predicate testpath/"markdown/README.md", :exist?, "README.md must exist"
  end
end
