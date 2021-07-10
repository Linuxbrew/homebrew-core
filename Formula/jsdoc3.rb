require "language/node"

class Jsdoc3 < Formula
  desc "API documentation generator for JavaScript"
  homepage "https://jsdoc.app/"
  url "https://registry.npmjs.org/jsdoc/-/jsdoc-3.6.7.tgz"
  sha256 "c081fb764e73565c2fbc5cfb559c3d0a6a3d82d337dcf146ece76a2ea17b99b8"
  license "Apache-2.0"
  head "https://github.com/jsdoc3/jsdoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f7e9c3cb44610f907e6e1094a24d5188f0b74f34c3599b08907240159c5cf40" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~EOS
      /**
       * Represents a formula.
       * @constructor
       * @param {string} name - the name of the formula.
       * @param {string} version - the version of the formula.
       **/
      function Formula(name, version) {}
    EOS

    system bin/"jsdoc", "--verbose", "test.js"
  end
end
