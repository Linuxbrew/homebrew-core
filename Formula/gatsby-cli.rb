require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.36.tgz"
  sha256 "4113ebd63a69f5519dbff536eae9ec5173d6f8ec93f2ce17886b2c7307caf9ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "26a84da0a831b79b4725c7d468510c7740d3edef9910f0bd7b321caccf962ef7" => :catalina
    sha256 "8812e72ef14b683a58f1160ae7d9673e5515446af88678c345d7513a8b668252" => :mojave
    sha256 "a3043c14376866799a7619bb3404c1a2601f5d4738c5de5ff4f4494f07202d9c" => :high_sierra
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log" unless OS.mac?
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
