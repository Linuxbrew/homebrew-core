class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.30.0.tgz"
  sha256 "928ee2bc26191371155ce01c5e94481d581557aee9e56739de345930e139b843"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9174afe265ef853edc7f8584f38e30cb0fc8e809faa08115ae134761a650fdec" => :big_sur
    sha256 "17632419c069f504a0523a6aaaafe7b7875ce284942152311e8a8a6a894ca460" => :catalina
    sha256 "6c369a7ce201fe19dcc591e226ae749812b9717e74b36288ed094d0a8f906e59" => :mojave
    sha256 "93704f9882080a50f87b2d0e8405f628ad87a0200726ddd82b089bfc71dad18a" => :x86_64_linux
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
