# firebase-cli: Build a bottle for Linux
require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.8.0.tgz"
  sha256 "402601a740eceae7445f551af06c8ab47f1092b3ed9528fa41bc4093b63b98c2"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "89308dd5528de0964462378990f0faeb8aa6c02a8e51feaefc9afaf933d73edb" => :catalina
    sha256 "60c37ad9735fe4533e191a30919905d7107dfcddb0a528f7c5587854946c4e4b" => :mojave
    sha256 "12d1966755616ccf1e7423179ccd4cb39ba0ad2c688186d4d113807d87a334f5" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # The following test requires /usr/bin/expect.
    return unless OS.mac?

    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
