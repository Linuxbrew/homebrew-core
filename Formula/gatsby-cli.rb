# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.28.tgz"
  sha256 "5dbea1c9d6f9906e7ae9bb087dcb9cb16fa4895aef6c084c8f80801f1ba628ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "9febe04cadb8bfebda030998b4337e685731d8dfbf7e85cf9f1c0faf3fd8a02c" => :catalina
    sha256 "3b8cfce5c3b3822cb469c5b4927034571f58b3663db5cbb3457ad460e1aaa742" => :mojave
    sha256 "dcd2b13743e50d11d4d50b96f753079bb215788bfd6049a9b89320fb48631c93" => :high_sierra
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
