# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.15.tgz"
  sha256 "3a67324ecf88ab1b244442b54f16c4f8b2de2e4b49f1859bb4ce27e3cb7ee421"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9621023dfb6f66faf444e7d1e5ee6a764fa2d8095689527328f09e1b617fede" => :catalina
    sha256 "e66bfd271e568cb085799c39d83e3fd454000736f8d582ba27399769365c8954" => :mojave
    sha256 "abc5e4daf90987c230a2ac9f15a26bdfa37f6af4d5a8cf511374941018d6fbd0" => :high_sierra
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    if ENV["CI"]
      system "git", "config", "--global", "user.email", "you@example.com"
      system "git", "config", "--global", "user.name", "Your Name"
    end
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
