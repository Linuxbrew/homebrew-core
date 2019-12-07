# netlify-cli: Build a bottle for Linux
require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.24.0.tgz"
  sha256 "3e8e49989ca275bb9ae55e7cfefc17bc7f60d6be9c8e412cf1d480d717c44b15"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae7aacf3a091cb4e7886b3530c1d308a2c1997079066332e9273ec5146df51b0" => :catalina
    sha256 "f5a07e5d51edbad89ff3074713e1500441cf847717e9e289f8eb0a164be85e1b" => :mojave
    sha256 "580e88707509ae8b758db02666d006e266aeaa1b66d6dc8bddc79c9e754a1df8" => :high_sierra
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
