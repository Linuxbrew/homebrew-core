# eslint: Build a bottle for Linux
require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-6.7.0.tgz"
  sha256 "d4bc29e56c5e825ff5acc3cfd248f4aa8be357539f9d6db8a9af6e8d3fa7ab04"

  bottle do
    cellar :any_skip_relocation
    sha256 "c79db1898766d7ba09ad4a45ed47675334f0a9c90f42b7914d33a8fd094559be" => :catalina
    sha256 "5ed6e2843965cd8a6bb8f7350191c9ccca6ef303c84a3c1e46d9082f41d02a0c" => :mojave
    sha256 "e6ba6134231e586148fecbaf19dca1a341e3faf79c5904839d570805f8a8cd27" => :high_sierra
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
