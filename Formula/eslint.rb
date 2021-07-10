require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.30.0.tgz"
  sha256 "63175a8581fa4ad2d28fe375f086b61066f30facabff83d0f76a4f8928455456"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "393e06101602c7f507b8b388bd1df1315a892e5750e913e937f706ccd605d429"
    sha256 cellar: :any_skip_relocation, big_sur:       "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, catalina:      "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, mojave:        "41fbaa9945c23e51be242b7756654113933d2b83818ad012ce6b19929e74042d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2402f23b47323b0a470e44034eb5cf62f6d693371b76a9385064696e89f38db" # linuxbrew-core
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
