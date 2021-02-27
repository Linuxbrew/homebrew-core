require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-21.3.0.tgz"
  sha256 "1385412d774c832cc80dbaf9c5f00e8fde97552f8d7559af7b21f57ea2920368"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37a3e8cf71fc4e4bb5dd3d0beb731bfd9199b0d171a1d97796b4ad5e7b28d35e"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e522acad0fe4de3c3327c2da20624e2e14f802a011648913b29b8c833abdae0"
    sha256 cellar: :any_skip_relocation, catalina:      "1921bf6e79e59feaaab85c1cdf3d0e3516d829672148f758f3823e6a56bebb02"
    sha256 cellar: :any_skip_relocation, mojave:        "90c0f7fbab259996f8e1d03de337b622831557f548787b39e8a8f9a8bd9f6c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86540e98e8c17737a2fec675820ec80422132ed95e289c64995e3c784cf5c6e8"
  end

  depends_on "node"

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "exports.default = getUpdateCommand",
                               "exports.default = async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
