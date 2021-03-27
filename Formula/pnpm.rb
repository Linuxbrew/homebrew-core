class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.18.8.tgz"
  sha256 "434dfda28e0619876c4d7a4d9df8209f814656e54198314e89f7abb9af543fb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca382630786708b1e913d7cbde18c0a61b3c0e33ba4986baf071f2602983f7e5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e8eef2ca1c94329fbc6d102d66dec5c717f315c70cacb0d9b2729c40a16661a"
    sha256 cellar: :any_skip_relocation, catalina:      "973915ecbe4a4ce213c00a3ff50c612009281c8894af00907e1a72ec291f58bd"
    sha256 cellar: :any_skip_relocation, mojave:        "f439259f509a07cda1f1e5faff75a335604b7852fe45bdb8e802a4c5353e2f0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a306fef500768a2d89af5218d8b5554a4c261a9f72b864e0aa1a8b3c91802f79"
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
