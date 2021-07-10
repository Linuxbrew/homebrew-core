class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.35.2.tgz"
  sha256 "65079d140b31e7834fe8856f1915ce32da3729beac13ab8b8750167024e1b012"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "29a0eddfb2124e8a1d017dfa65199cf90cc6007727aac2462bb28618a3fe5692" # linuxbrew-core
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
