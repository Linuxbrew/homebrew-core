require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.56.0.tgz"
  sha256 "e48c5b8748e81a0f19b17ca882e55aa055292929c2588bc27d5e40c741b0aa44"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91a9b111fcf8e9369c27627dca3649ba5fbb89e60aed80b613bbf2ce84973581" => :catalina
    sha256 "65fde49929cb622469c83777e405126df49a96b0b243d984d7c714d56b9486ea" => :mojave
    sha256 "2bc96aa52fb0758cc9756e40a2d20f8220dae9d1796a2892bf021a6dfecde215" => :high_sierra
    sha256 "0803ce602ca4b9799c835a52a77b65dad9232530b6ffd4f1ffb22f5f58fa341e" => :x86_64_linux
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
