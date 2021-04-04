require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-3.2.0.tgz"
  sha256 "2885c6b85d27df93a8824df90b784cf8ac243741b5e4f3778338d4839344ddf9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "51ca3ae5b55d008dd87ab53fa156f58d1b8ac367dd3a5e734a8cb2dc36ebbf51"
    sha256 cellar: :any_skip_relocation, big_sur:       "b49c987c8226b9f30da19335ed33c6fad18ccdbc0077657d9b14fe15cddc9282"
    sha256 cellar: :any_skip_relocation, catalina:      "d60ce049a2ed3598382bc005239710ade31fa0cbb5c06c0dcf5a11a9f7cf1ba5"
    sha256 cellar: :any_skip_relocation, mojave:        "a5856a6e6b88aeace5ed028656c70614f3dee7e73ea056f08b8d5c023fbcf26d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Avoid references to Homebrew shims
    rm_f "#{libexec}/lib/node_modules/gatsby-cli/node_modules/websocket/builderror.log"
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
