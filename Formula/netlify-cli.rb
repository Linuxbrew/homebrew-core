require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.50.0.tgz"
  sha256 "50885d4a1176b82e1727d92d8cf6cd12f1c6b57109cd292c90ca49b8c06d5724"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6816f6046c50d43ee6f87c2fcdb9fe7216962cbbe3b77c8942572b41c953f192" => :catalina
    sha256 "f5769fb7c786675a57e20421146ba935e173a74289f5f92776f4dccc0d4d33c0" => :mojave
    sha256 "93c6f29e7c49541ed50568debce4bc628be7905985cfae13f9ef38467ebabc70" => :high_sierra
    sha256 "f51e072555a6b0e9ddd548fbbe36e00c22ff1e415fa8cf9c027be56ea6a85fad" => :x86_64_linux
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
