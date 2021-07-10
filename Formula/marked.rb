require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.1.3.tgz"
  sha256 "73f5a3f0978655b91a77dacd6682891ed33622b6480eab267bd153d921f15d48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "e48abe8c593c80cffb44aa0246820bcdd763c6314cb6efe4c8b49511e6a78ead" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
