require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-2.12.15.tgz"
  sha256 "aca45532e0aa9e3d455a0a2a83cc9ce2b4f56a3703082c7446ad7afeaa5cf5b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1fc48b8a6b13babd742e9986632e66502ccaf24c0318b2fbdb59a2f0162b174" => :catalina
    sha256 "6282d66688865ecebf48ca71fae98562b56720d43b253128eaf8336c436ba7b4" => :mojave
    sha256 "8e579cbfadb4886f148478a06d005606448b35a58f818cc6dd82a96e7c016366" => :high_sierra
    sha256 "d21a51e8316bc67bcfeb7c6f06495a158e3582330d3d9d685ab942413c7665f7" => :x86_64_linux
  end

  depends_on "node"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    return if Process.uid.zero?

    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
