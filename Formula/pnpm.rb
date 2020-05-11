class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-4.14.2.tgz"
  sha256 "f9e3d3c34c9cb5298702fc5ffd9f082fd0c381f78b586b02a64dabd5c3d02fdd"

  bottle do
    cellar :any_skip_relocation
    sha256 "9619bc4a88c4c9235357e5d926b81aa444d26b322c16b8675d2d834188ba3ddc" => :catalina
    sha256 "986de8a46fbc3cca2fa97f7ffae6a528d45413b83336384fb72da2918f68c15b" => :mojave
    sha256 "1922f67940bffb5856765afa4ff70a35fba9ca5d257108ae0b3787e4ea11afa1" => :high_sierra
    sha256 "a01578dd0af3ed1a7bda246450f57dbb8a61614c8dd41e7118ef9345be4a5eb2" => :x86_64_linux
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
