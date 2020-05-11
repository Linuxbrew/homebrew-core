require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://github.com/awslabs/cdk8s"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-0.20.0.tgz"
  sha256 "c0aa8c9371fe99440331553a466b4e875e1c6850b2ee3580082e58dbbabfef01"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ab8a9f9dcfed6fcd3d19bb379f3ae42b5518880f72967655f00d2d46c5608e6" => :catalina
    sha256 "fb6d45ae8301b35839e42a94d93606e93a39777eb8196fc28d96f34a2cfa7912" => :mojave
    sha256 "ff0aa267d43e5afed2aa0ba6dd4fd179ca7cc0228bca56fa50f09f8893a4b809" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/cdk8s", "import", "k8s", "-l", "python"
    assert_predicate testpath/"imports/k8s", :exist?, "cdk8s import did not work"
  end
end
