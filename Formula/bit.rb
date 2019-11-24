# bit: Build a bottle for Linux
require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.5.0.tgz"
  sha256 "d6732b0c45777d1c6204e7d481fd2301b853ee4cc324388c43c17bc1d4178415"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6952ee6f5014120b7b09db06d4608a9bc689f0bce8fb5ee8c1a9aa414e89454a" => :catalina
    sha256 "fd4356dcf32e7f51707f2a47b4e63de6303567d0c7b3380f0c8c225693882c76" => :mojave
    sha256 "15a06016ca967a679f854296124edb73ddacaaf4bccc5d1e739cdb155f081c27" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
