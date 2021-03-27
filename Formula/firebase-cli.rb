require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.7.0.tgz"
  sha256 "a36a1a547ecd2164fa939e87421b90ddaf87ac88d1b02e62b8bcfb2252082409"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "79c5c5ee44eed956836d8c74efd233abe8a87287c0f32110848aaea566857edf"
    sha256 cellar: :any_skip_relocation, big_sur:       "b8992700bb9e40dfc293af2d94cf4ff1ef10e8b332064ef0f1c7725715ae9f6e"
    sha256 cellar: :any_skip_relocation, catalina:      "26988c01500b1a4fc73c7b12acc8bba4b428a93e68d378bf62c946f4777d1f4c"
    sha256 cellar: :any_skip_relocation, mojave:        "b36064010800dc3834b5d7a9651a9b91ad74809200fedb78b212f568d0916736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b88e92f72ab59dfd0f1e3a6a73cd1d625dd0ff835d392b479166868fc9e41e5"
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
