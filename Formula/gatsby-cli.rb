require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.8.30.tgz"
  sha256 "60184a89545c65a6be7a81f676e9c11b6c3ab8354a3db5340f72d4cd4dcc8f92"

  bottle do
    cellar :any_skip_relocation
    sha256 "93108093ed2f6f126bccea11519681dbb53781f0257a9e956ebd06b84e3e4013" => :catalina
    sha256 "a4104803841579af9277f2e106ffda644c35ae061f45f4e9c4c8e7fbabd55abd" => :mojave
    sha256 "f71999f4df1c9907abd1a26a12d83f50f602cf7057568d6810544010ac18cb45" => :high_sierra
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
