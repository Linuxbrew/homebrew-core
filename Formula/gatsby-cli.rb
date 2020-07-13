require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.60.tgz"
  sha256 "070cd7da3e1cad1b1ec48233c4232f38c444649dce918d8bb731b5b2c363c578"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "d969a1f544386351e13ef846d3e281d541291f93372f6c0fe9446bbe89f32e0b" => :catalina
    sha256 "34ea6a1dcdae2560be9e8f4f41a7a088cc7d46d0c744738ed94dd62bbf38eace" => :mojave
    sha256 "8d8b89972f41d425bc6d0fc2ee0ee6ea19fceac6ed58a2ec28a6e493f556828f" => :high_sierra
    sha256 "464f7656d14f23a10401d91e2faaca57296f50b9e37717311a0a157231cf63c6" => :x86_64_linux
  end

  depends_on "node"

  on_linux do
    depends_on "linuxbrew/xorg/xorg"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
