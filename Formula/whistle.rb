require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.32.tgz"
  sha256 "f23f8210ec9c0f3797d759a338f9ce058e2a9c051af4ce101d45a9b06afbcc5e"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d80d9c648bfc417b590c5e572fe765cc2bc7a0054eb300a73c271afe88ddc928" => :big_sur
    sha256 "772e47590577e57b17437332392c7bb2ac939b5756a47993ba65e3135e447ab1" => :catalina
    sha256 "054e3c98997577be27f1439315704bdfba8b823b4d7d3aff2e4bea0e4d1e1505" => :mojave
    sha256 "f9ee5deed70a97c91b62dc19a25ff010c97e218513946026aa0333a6831b7174" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
