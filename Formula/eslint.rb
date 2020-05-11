require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.0.0.tgz"
  sha256 "a99b1c56f1577a67ac4de68f66088deec90a332373cfd2a9adf445e60f91cbdf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c4bff2e3ed52e5922bc116f88465683afcfcbdaaaf2aff07a3e2e18cf61655d6" => :catalina
    sha256 "d9bd75aaf19a7cccb707319fdda730bdaccaff0464fa68282426e732df98351c" => :mojave
    sha256 "7f1734076e1f3e070a0d3a527ce4e99ff8bfa5593ea92a16dd6bd3398898d4e7" => :high_sierra
    sha256 "51f0a3b3929fa25ea7c274eef86bbb1b90117e4195b47912b0fb25c545f1a06d" => :x86_64_linux
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
