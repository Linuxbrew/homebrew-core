require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.3.tgz"
  sha256 "f8ac89b0f97ce52ca89f964966aafc8d0dc33b53341f68245bd1a1776f973477"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "805e450cc6e60d3a54b9bc7a794c68a89dbc45eb04042025f120dfa7d106e551"
    sha256 big_sur:       "53913c7ee4d9ee2d7a04bc3bfe2d6638a18e686391defddee4d4fff2053a4017"
    sha256 catalina:      "627838e27e569740c023bf88d23bb213be3ba42880d8ac304e5087e73b58e776"
    sha256 mojave:        "911861ad1225f6eb0c04ef03de0879305aba91dd171de39482d79f90517d265a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"truffle", "init"
    system bin/"truffle", "compile"
    system bin/"truffle", "test"
  end
end
