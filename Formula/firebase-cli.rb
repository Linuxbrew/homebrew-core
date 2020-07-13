require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.5.0.tgz"
  sha256 "8a752f907dc2cd6be29f17b96f4a081edefffe986a835421b8b9e4216c5c4364"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76a19a1f8ebe04cca81bdafbc90bf14a18d2ed3df3d5a742f43f3db293590409" => :catalina
    sha256 "b0d04b26b06f4a56fac5bad62104fc1dcd6dbf80022fc69474a4a8e5ba73c810" => :mojave
    sha256 "84aa5df335a7fe3e3b9e4711bf13255516925bdfa57a63446a6c6098218218f1" => :high_sierra
    sha256 "5cd138bf59fcd784ab37962414ce9da3d9bba1e8b1cdde72f52f0ea935c62bdf" => :x86_64_linux
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
