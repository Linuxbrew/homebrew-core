require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.19.tgz"
  sha256 "e16539708c6596a2772d675e1446c8e6f2b058e97a0252b5c71b2260372f5b93"

  bottle do
    cellar :any_skip_relocation
    sha256 "25693bd9e993ef33aa3f4727bdfbd0f0c96c31c7219eb4bc7d1721725b0db3b4" => :catalina
    sha256 "279311e2ddf3c6370c22fa1098608d58bec9b580844728451396acabdc0247e8" => :mojave
    sha256 "afec321ca76e48bd4481f89a92ed100f128424e58654f764280b3de7e7020a85" => :high_sierra
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
