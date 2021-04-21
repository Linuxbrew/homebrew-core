class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.11.tgz"
  sha256 "a1474f07474e93de62e05b4a8e9f7d325f0fe423d47d5da9a80b5b4b82e05beb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "659066bd9030dc33c089a70acb20eff4e7db905743fd323a7dd14d5ba5e51851"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1b61dc6575541fbc3087d3671aad326ff2c0f6bb51e5f20bd535dce0df3b7e8"
    sha256 cellar: :any_skip_relocation, catalina:      "b1b61dc6575541fbc3087d3671aad326ff2c0f6bb51e5f20bd535dce0df3b7e8"
    sha256 cellar: :any_skip_relocation, mojave:        "29374b80a9b97eaf8ea8b3b11ceb27465c7421b5a7fea44ad068d82aa6e6a0ac"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
