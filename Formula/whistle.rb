require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.14.tgz"
  sha256 "ed2f68d51f815db9ff85c481f1a291abd6eb6227aba3644a0b029e790537347c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, catalina:      "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, mojave:        "ddc9b441830836a9ea783c406626abe7076a8051a9bcd6f8c09fd1a446e50f5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf95c8af893b51f5898bd3b7c448c21284b1558546de9c7fcca6d5b20a1aa375"
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
