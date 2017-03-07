# yarn: Build a bottle for Linuxbrew
require "language/node"

class Yarn < Formula
  desc "Javascript package manager"
  homepage "https://yarnpkg.com/"
  url "https://yarnpkg.com/downloads/0.21.3/yarn-v0.21.3.tar.gz"
  sha256 "0946a4d1abc106c131b700cc31e5c3aa5f2205eb3bb9d17411f8115354a97d5d"
  head "https://github.com/yarnpkg/yarn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "20ebc2f2bce300095a0af7b9ef2aca712992bb24a8410424610ed133c3eabdef" => :sierra
    sha256 "80a321ef5d474ce6d4093b994f425f43e4de05cf93b366c29190fe618fc4711b" => :el_capitan
    sha256 "086f619f9712c9e012e9c1797db630b2118e2d91ad3ebc8102038d3da427353a" => :yosemite
    sha256 "e15b3df13135e186958ed3a18cab03952d2caa4b2410b3a016fe4d9f8416e87f" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"yarn", "add", "jquery"
  end
end
