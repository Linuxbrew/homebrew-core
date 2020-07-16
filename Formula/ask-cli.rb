require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-2.12.0.tgz"
  sha256 "417f32c3c0be94bb5cf087b862a553436b999aa8bff6f308f3f6218961842964"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "63bf73f00ae82eb0dcdd49850484defb3690fabd09fea609e39fa70f6652cc7a" => :catalina
    sha256 "dfa46da11d7915bdf9789d8773af8ee6addfbff671a2f4e3b8b78a39bf279bbd" => :mojave
    sha256 "93f5a33f9e993d9c2fbecad9d53f9378e9d92b022585cbcbf6cf1bfdedd77a63" => :high_sierra
    sha256 "00d5bd71edcc285e98ce0456b7bb1f34b65b28acbf6739dcd3cc8dfb3fd8447b" => :x86_64_linux
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
