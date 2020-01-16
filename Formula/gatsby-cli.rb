# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.27.tgz"
  sha256 "bc413ceabb78ff54faba810cfe83c8640af3bf8ec879e0f92d5ea3fd18f2d613"

  bottle do
    cellar :any_skip_relocation
    sha256 "163d6ca748050c6d46ca419b0cb3a31668168a5cbf0d584c14ef9ea0ebd9e6ed" => :catalina
    sha256 "9cb68a86826b61d5deed0311842ac602e57367eff80ffa9b5f7902535d5cca24" => :mojave
    sha256 "d5efc43086ecd9f94f43b59b8dc5b0208e566cc07ad3f4edf2c436cb4033862e" => :high_sierra
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    if !OS.mac? && ENV["CI"]
      system "git", "config", "--global", "user.email", "you@example.com"
      system "git", "config", "--global", "user.name", "Your Name"
    end
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
