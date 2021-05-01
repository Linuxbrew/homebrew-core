require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-22.0.1.tgz"
  sha256 "e365b176cdce22da8d3f44c7ca6853b1d8cb5b47930e983fe2d3bb97f807c066"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a4994e34124282ee52988742bd544473c5914cacf102aaea1e329497dada8f78"
    sha256 cellar: :any_skip_relocation, big_sur:       "cb66cceed1103f5620cfc099b7cb06128db1a5ac2cfef99dcdf6ea5bbb9e98be"
    sha256 cellar: :any_skip_relocation, catalina:      "cb66cceed1103f5620cfc099b7cb06128db1a5ac2cfef99dcdf6ea5bbb9e98be"
    sha256 cellar: :any_skip_relocation, mojave:        "cb66cceed1103f5620cfc099b7cb06128db1a5ac2cfef99dcdf6ea5bbb9e98be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9813fea9262cf3587414c430e3611fa04a6079f965e1107937f08d2bb33acd0b"
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
