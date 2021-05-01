class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.2.3.tgz"
  sha256 "54c05ca152dba43f5681580978313d43380518d347a8c388eb5bdccc9c646021"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66b79b62333d32ba03d25196691c6526a6906ec97f2f75578362cbc8bb437096"
    sha256 cellar: :any_skip_relocation, big_sur:       "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
    sha256 cellar: :any_skip_relocation, catalina:      "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
    sha256 cellar: :any_skip_relocation, mojave:        "e288887deebdf1cd1683af2c00a50ed1931e66ab7767aba0be19f57fad738f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727291106ce665f2f2dc95b64b36529c30d1ac188d6ecf393b5f124af37e0091"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
