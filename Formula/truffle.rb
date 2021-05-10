require "language/node"

class Truffle < Formula
  desc "Development environment, testing framework and asset pipeline for Ethereum"
  homepage "https://trufflesuite.com"
  url "https://registry.npmjs.org/truffle/-/truffle-5.3.5.tgz"
  sha256 "814da84b3d520ce508db34fa85d6673bc1683a7eb40d1c44b5a6de766dd4817a"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "e28589f117ca61516675b013a98b0f94342719b1ec6ad05e641a4f248f4ec673"
    sha256 big_sur:       "83e7de2433fe38ae9c9516dd9b86debc4d7ce853f2436097a897f750b36176f3"
    sha256 catalina:      "e35b4df14b7bde64059aff848dd3866f1093d3b216635a1ed0e0cbbbe44b3d59"
    sha256 mojave:        "03efbfd223600c462f9f16dd0c1bc871f9cc4dce4d3e3fb2c7f3802d20a5aa7a"
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
