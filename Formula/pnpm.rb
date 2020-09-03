class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.5.7.tgz"
  sha256 "fe7bed0a708da7b4ba8b32ce5d0dd5ee8f317997ebc92a6c06c152e9fa9a883b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "2d48087e3cf42cdbd6238a05da9329e582b0a69bc3b77693a652c7092c059d2d" => :catalina
    sha256 "02721a3ae01a23144cd891c9acc1b4623f4b6af733de8efb30adffe3da4dfba2" => :mojave
    sha256 "0bf65c66323f44068c464dd0e1434ebdde1cd27d16936f5251ed4382446a4637" => :high_sierra
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
