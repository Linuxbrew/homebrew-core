require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.17.0.tgz"
  sha256 "9f5031ce022c61b78923d7708909e7ffdbbce5ffee154b5089fa931a11012a53"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5cd2303198a8b969b281a78b47fa4f5cbbf2b9d908901c23feb53b8971dc4570" => :big_sur
    sha256 "0fcd8c8ce8a93c08117dfd3eed1a75399e1e5361f94ca6311adbc73bc80bea7f" => :catalina
    sha256 "d151b81879db642ed4b489dcfbddcdcea29d3fa77193c74ebac4f472fb1bd5e6" => :mojave
    sha256 "b8e26d1d340b1428858beae78b79af482eff4abef145c4f5e90fb51bf138db2b" => :x86_64_linux
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
