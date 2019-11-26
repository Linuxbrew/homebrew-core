# gatsby-cli: Build a bottle for Linux
require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.14.tgz"
  sha256 "478307602138ac03d6ff73c9d41f1c4a36302146f392875090608d2197a2fa8c"

  bottle do
    cellar :any_skip_relocation
    sha256 "44259be85193c7ff310ea567c368e5053a80606a96853f8f1a7e34c08e75286e" => :catalina
    sha256 "5b5596821da657ed00a1865a2803318e6e8adfa8a8bd631edad0b8b105cff822" => :mojave
    sha256 "07d305be827c3d7bbe3e2cd08cd45b0a64cf5e492b42d4934913d0f1a5a388f5" => :high_sierra
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
