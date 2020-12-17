require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.9.tgz"
  sha256 "acb146749ef170a8ea9a342b13c0ff9d949800fc8bafee6fa25347a9626c550d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "24be555a49d4e8482015178048c1ed265efa454d3e51296d8bf12e5e0f515b3e" => :big_sur
    sha256 "41c828584aab1af6b82054bdd46a7bfa753b72016d999b0317e2ddfb77fb4e1c" => :catalina
    sha256 "bf9e9a350f0478a5bdb11069d8137b9c3f65982a76fe2f825d9b41a98ab8641b" => :mojave
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
