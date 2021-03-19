require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.6.8.tgz"
  sha256 "98809d595bc9c916b9b88c8c22ec54c7ace195cfdf130c4932d71b951ca6f787"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5454c50fd73f112646a2aceb332858f6f1faf58934b509a0bf76ee69f6c09be8"
    sha256 cellar: :any_skip_relocation, big_sur:       "10b31327cb974125a9e47e377e7f986485542460b40412f485f6de82b80f2353"
    sha256 cellar: :any_skip_relocation, catalina:      "0dc7d260fbec4a3f3ca13128f21d22f593b12c4dc4165e28d26de109ee2c7840"
    sha256 cellar: :any_skip_relocation, mojave:        "954d72a6a94f085e723d84cf8b520a22bf269bade36a64af43cda00c04aa6fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dc84620536728539979d35adcc03b1d38ab68b4929b3414ce2b32af83fd6b6"
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
