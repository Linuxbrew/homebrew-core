require "language/node"

class NowCli < Formula
  desc "The command-line interface for Now"
  homepage "https://zeit.co/now"
  url "https://registry.npmjs.org/now/-/now-19.0.0.tgz"
  sha256 "d3290b780b6dd0c2f6eb6d6e807cb7c747aba5fc00349390551900b2c71ab497"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d2e9f5b388be74d6756ec222cd2e3854b42d96c029aa3c0aad07eb770ba7b62" => :catalina
    sha256 "13981fbe26c9432dcc30c0251ce8f08990d137b14e5024252e8c559d073ad1f9" => :mojave
    sha256 "326d5abdbde9f86424965da1a126d99424af28592f27b29f56fa029d7a3da03d" => :high_sierra
    sha256 "be905290a796f17e6fb0a1420052dda63f8b96378e3b22e0805f87ea501b45d5" => :x86_64_linux
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
    system "#{bin}/now", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
