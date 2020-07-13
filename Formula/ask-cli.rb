require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.11.2.tgz"
  sha256 "57b9a94a63c1b2d2be63e2a374ee84f3e4bc5547e4430e14c47e72ec81f0ff76"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "475e6b8c27a3e451554884fe73148f0107409c034202fa85fbd0c9eb355198c8" => :catalina
    sha256 "64d3f6577a7247cff4a0cbe9123f2e966f8dfddcf4e0b58b0b925642d6953ea6" => :mojave
    sha256 "d4b5c2f5efd7b4093a41d6699a3baba81484ae1b728e3bc86d79b16c7b96056c" => :high_sierra
    sha256 "715561e381759856adf78969205b47356a84cbf705e5c874764b452b736f017b" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.write_exec_script libexec/"bin/ask"
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match "[Error]: CliFileNotFoundError: File #{testpath}/.ask/cli_config not exists.", output
  end
end
