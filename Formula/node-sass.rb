class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.12.tgz"
  sha256 "47f45816d421cc993bb59bbe1d5218e1ca426f0d924519a2408ba5152544301e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2959624b851f27b5c9a749eabe9b56023091a0872b8203dfaaa33da89614c538"
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
