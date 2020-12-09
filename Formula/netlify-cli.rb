require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.1.tgz"
  sha256 "5780bc2aaeaf31066eb1ff51de1f2f76470f477c16f75e4ade571fba7e4479cb"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d84fbcecde29f2e722d6d90e0a4bc2ddd2546171320cb942a0b927d77c721cbc" => :big_sur
    sha256 "b50692c58db901ef4167ef96e8c74b3380a75bc86f812a482d94065185ac7594" => :catalina
    sha256 "8ee7df5a9845ee24c6565b5d70b2eaa402b1483d06d85a44985ee7209ad7ec94" => :mojave
    sha256 "2f0cefb783109eff6581d472785bd14f847c964a94f16f2efdd58f98fb8709ef" => :x86_64_linux
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
