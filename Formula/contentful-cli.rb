require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.10.tgz"
  sha256 "4149e29df422b6584d64d4b9d81c95648ed4543835ecfb3e754d0794359d427d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f401fb3a27c94fa812ca58568da57be7f6e1cdeeb190658f3c53b02e97200118"
    sha256 cellar: :any_skip_relocation, big_sur:       "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, catalina:      "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, mojave:        "81199be135f9ba2d27bda1a2ad20ae2d154df533a0502c491e7fe985c3a99d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "19651d2802ddf081a046def3222bbf4f03462866b93640d57df3eca478524892" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
