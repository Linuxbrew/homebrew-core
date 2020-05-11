require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-8.0.7.tgz"
  sha256 "14390eca2632a6bec498f9946a7cfb52abf052ab20e395b70edd054255fbd349"

  bottle do
    cellar :any_skip_relocation
    sha256 "a87772bda684a90e032480a91ab7cad00546c545e2be54e40f2665bd4ce4afcf" => :catalina
    sha256 "3f20cb28094faac504d879e8cbeb01c785ee9d1cc1c0bc1a8607a2db78176f4f" => :mojave
    sha256 "f8005868540a210382084f726160f4d22352e122442a617317a8f88d6cfe7dfb" => :high_sierra
    sha256 "0ef784191f166577799d1022445543d65dc00efa15dfd14e798a589152aab4af" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"nativefier", "--version"
  end
end
