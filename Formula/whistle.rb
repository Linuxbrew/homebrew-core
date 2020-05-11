require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.5.6.tgz"
  sha256 "237d68e913125cdc10afb27bf20338c787e17bb8e4aa521a7d286787322a0666"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc42d28f5ea0cec9d0118aebbea5e8f487550bfb35c2e0684a4038d85cc3b904" => :catalina
    sha256 "66f5c80be1320c66899cd916b5f70c488df12fcb56a6c78dfed12c68ee86b81b" => :mojave
    sha256 "3f4f87ddbc55a6a9a0cc4a15588deb9b634d8a34fa8ca6f3c946d573204c6146" => :high_sierra
    sha256 "f25f2747ed494e50b80bd346dacf95b347a3dc0edf4d747e8b671a2defaa8381" => :x86_64_linux
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
