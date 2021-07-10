require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.6.tgz"
  sha256 "9bf716cf75ca07b7bcf8005572af0ea695aa80fff0b4102c018da569eade420e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "39e50aa778c879ba8d2089f6f11bd26db9cee0da015986fcc6b354caed4e0f98"
    sha256 cellar: :any_skip_relocation, big_sur:       "be08de210a106ccd5650acc595a032c14a994f66be4e36e332b30c9c01b71bd3"
    sha256 cellar: :any_skip_relocation, catalina:      "be08de210a106ccd5650acc595a032c14a994f66be4e36e332b30c9c01b71bd3"
    sha256 cellar: :any_skip_relocation, mojave:        "be08de210a106ccd5650acc595a032c14a994f66be4e36e332b30c9c01b71bd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b4945a82332bb193672380c9ca2a6079c1d0947d03389442d967307e8fa34d8" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
