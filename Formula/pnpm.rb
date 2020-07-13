class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.3.0.tgz"
  sha256 "afbb61ea8be6b48c57eeb00a62049468be8a64a032ffecf53c73bef0d9f3efc4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "9c9c85fa26f5bb369ffcd5cd44da68da46115e978714c047ba7e6439b03b7cb8" => :catalina
    sha256 "b3efdfc6c62704ed71fc66b38926f43924bb1347f224cc9c554ca1087c33f4e7" => :mojave
    sha256 "a36bfca5a0b2ab1bf83d748a1922b14e95dd2668805388c43919906c5e803ad7" => :high_sierra
    sha256 "20baf4ce7d16b21e8b3e212b76a431b63fa62193b9e236929550faaf9c65c5a5" => :x86_64_linux
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
