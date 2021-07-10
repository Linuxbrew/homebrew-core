require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.1.15.tgz"
  sha256 "e2c251946647906c8285834d00be25e2ff14838e4dcd3cb2c52befa0c89e587b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2db7500bae3956a0fcb1dc0058058e43bc94f49d61b65aaa38d14d8b0a11ad00"
    sha256 cellar: :any_skip_relocation, big_sur:       "efe3219680738938df1665c359f7bae3e89f4c9d9c3b6af9b74ba6a699d342fb"
    sha256 cellar: :any_skip_relocation, catalina:      "efe3219680738938df1665c359f7bae3e89f4c9d9c3b6af9b74ba6a699d342fb"
    sha256 cellar: :any_skip_relocation, mojave:        "efe3219680738938df1665c359f7bae3e89f4c9d9c3b6af9b74ba6a699d342fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4f763bfba47c0a3de9520fd6cfc02c42be53e6046e8db18fa63a0803ea6890" # linuxbrew-core
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
