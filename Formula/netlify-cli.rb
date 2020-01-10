# netlify-cli: Build a bottle for Linux
require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.28.0.tgz"
  sha256 "b0e800604efffb186f21fc3ccc0a1fd88aabeec25d60f6338ace694b6a46f4d4"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15847bb83ea3f484dd521fa7b77770ff99db009553742481e75dbb7e94496134" => :catalina
    sha256 "3c9dbcc048d7c309ee63aabca67eeddefc5cf96305ade2657f4fbd31b91a24fa" => :mojave
    sha256 "970da247232409d84a335a8740a8b298280b5928e172a69ef17621c964ae6236" => :high_sierra
  end

  depends_on "node"
  depends_on "expect" => :test unless OS.mac?

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
