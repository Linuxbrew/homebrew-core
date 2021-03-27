require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.23.0.tgz"
  sha256 "7c722e8cc1878c4613203378d963f4fec347409746de9ce44011f63e36fdc3cb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64458615bb4ebbbe500b0efb985698bc7f78d609ef7faf2523c0c430a981023e"
    sha256 cellar: :any_skip_relocation, big_sur:       "6d682f337247873d37d6483e97b9543fa9eb58d969ac414781434f6e2845ba35"
    sha256 cellar: :any_skip_relocation, catalina:      "6b531eba34aa5107936c8d067900db1cc003b0580487ac7c2c4126e458bf75fd"
    sha256 cellar: :any_skip_relocation, mojave:        "b2d83e96e2f745e38a7d2a0fff9d7b2f07836b5d211a8448ebe8412d6dd6fffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "26492ccef5e3b0c6f07be0464b44d8d9366333aa1eae0d14e0e6fd0831b24c47"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
