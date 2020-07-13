require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.11.tgz"
  sha256 "a974bfbe24496c4da84f9e307e97274d0944d9ee9505e74cebef1d21c0f7835f"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70e80f17737196a2b6ec3d77dc0cf0a13e20be178ad0e4369bad6cf58861d930" => :catalina
    sha256 "a406bfb1c14dd88d5ebe25e49173e910ad9e499bdc029320e84c5f43c317295e" => :mojave
    sha256 "1ffc310d2341b9a2d04954abce3fbcc045b09967e59e620780a178f139e88122" => :high_sierra
    sha256 "641cfe6dba3e525a754516879b8d5c9f9cd1c42b21a667ed61f521cf6c2163df" => :x86_64_linux
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
