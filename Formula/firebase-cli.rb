require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.16.0.tgz"
  sha256 "93177d8aba4109daf3628b03bf4adfa8f790015644e950dcdaea2c0b0e5963f5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "cb8888ba0ddc3cdafd621bc8bc533476a0f2adc8494031af8cc72dc0e9035abb"
    sha256 cellar: :any_skip_relocation, big_sur:       "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, catalina:      "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, mojave:        "8c8539d00283d13fe2410c2abbae5fdcf429a6de54b9167157a205ab2999b935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a3f54009181480bee96b9ae62cb501e6839249ae7bd4f351def6f78042ddd18" # linuxbrew-core
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
