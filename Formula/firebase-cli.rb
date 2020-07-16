require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-8.6.0.tgz"
  sha256 "10b2ee56be0ea6ef258a83c3502b1eb81e111da112133d671d81d9108585e7ee"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0867f98837f6b4713611c61d91662207468075cb81a629e546e49142f975aaab" => :catalina
    sha256 "1d6167ba60203a6287ae591a1ed55f27437375c7a92c514831e74da05b1d4387" => :mojave
    sha256 "18a5d244b30766249c863aff38fe61474501646bc377c241c8104f2a522d39ee" => :high_sierra
    sha256 "4bcb4989e8fb130a9aa148c7871cbd69f40e01e8349e158c3248757913c31ffa" => :x86_64_linux
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
