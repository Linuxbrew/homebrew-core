require "language/node"

class Ungit < Formula
  desc "Easiest way to use Git. On any platform. Anywhere"
  homepage "https://github.com/FredrikNoren/ungit"
  url "https://registry.npmjs.org/ungit/-/ungit-1.5.14.tgz"
  sha256 "b1742503cf44ae662cf3eadb28db1423186d9d52ebf7af398a99df23a2525e57"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0fecef00159d9b7a698a3957ef6052ca7601b95dbf8346eb7b9f400043a7f67b" => :big_sur
    sha256 "fcfe3b9a356be9c3656d5f595659b478a2c1c3e90611b4bb7e6756dee1789e3e" => :catalina
    sha256 "52ce944c2a1678eba35fdfeaf83381d2e2cd8c29e8c9c449b95d49ec0260574e" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port

    fork do
      exec bin/"ungit", "--no-launchBrowser", "--port=#{port}"
    end
    sleep 8

    assert_includes shell_output("curl -s 127.0.0.1:#{port}/"), "<title>ungit</title>"
  end
end
