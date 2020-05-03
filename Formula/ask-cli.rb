require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.3.0.tgz"
  sha256 "39753e37459a687942c96d07126bfaf404390081a9d9477a53506cdbdae0a692"

  bottle do
    cellar :any_skip_relocation
    sha256 "c09a4cc43bf72b7d5878eba6cb7a835ea8250f210e3bb30c6aeadd9698ed8ae8" => :catalina
    sha256 "8e3d8bf4f7376d71f4b316e566b8a5270d82e5e6b091eaf3ab2e5c26616648d1" => :mojave
    sha256 "f84f9c583922fbd2ec5ad5cd2cbfb8f78072a483e3d13bb5003a1923a434e01d" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "cli_config not exists", output
    system "#{bin}/ask", "lambda", "--help"
  end
end
