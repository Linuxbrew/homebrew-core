require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.7.0.tgz"
  sha256 "a276a130cbd5f9a0d774f2d80cca0248e052d2f8dbe06f0a281de5154fed655c"

  bottle do
    cellar :any_skip_relocation
    sha256 "a02aa11f19d1d42c6d1b554c1e34c3776e8637fa17922cfcb34107a686f70bf7" => :catalina
    sha256 "0f6cff7b57cd022b7f6236e3cebfb9e5809b2ea0c52ef2757bd46a312b9cba70" => :mojave
    sha256 "cbc6c31b4b7e811dbc00b47509ee32d67fd13dd2268499880fb7723a785a5850" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "no such file or directory, open '#{testpath}/.ask/cli_config'", output
    system "#{bin}/ask", "lambda", "--help"
  end
end
