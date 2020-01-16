# triton: Build a bottle for Linux
require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.7.1.tgz"
  sha256 "707dc14d86e5f2ef70bfd3821fde4dbcee9c26b2b6f6b88e125336b3d432077a"

  bottle do
    cellar :any_skip_relocation
    sha256 "daa2bdaf7312d926f69ce66ca768593dea9cfb94e0e6eda9568d700e99e0b005" => :catalina
    sha256 "a0943d1584dd4abe73b409b260db8c830c1b14f5c97845f8d79fcc35aa16cb02" => :mojave
    sha256 "9b656ba4c57181766a04da5ccc8a0fb4a24849ba3b97729e3d62c9890759b6ec" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
