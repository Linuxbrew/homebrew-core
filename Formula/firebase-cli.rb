require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.2.0.tgz"
  sha256 "21a119f951b4d300e1f705c76313b392e003087825371a2cafe5378c3b4a1843"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d7d0b73c979de2854c0bc8cab7392bc62d6aca43714fca32cae44c64622f429" => :catalina
    sha256 "c4a105ce326494f0fe675ce1ed126f6afbb728558d67656ee4f78ae7b7d25113" => :mojave
    sha256 "a529fd3ffa34ab7aad3ebf8e65f29c645897e3a019252466b9b6146453ba7b8a" => :high_sierra
    sha256 "ffee524ad5cf5bde8f41f9815e4d76dc2a4ba37cc141501fce4612ba3baae7b7" => :x86_64_linux
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
