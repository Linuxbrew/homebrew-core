require "language/node"

class BalenaCli < Formula
  desc "The official balena CLI tool"
  homepage "https://www.balena.io/docs/reference/cli/"
  # Frequent upstream releases, do not update more than once a week
  url "https://registry.npmjs.org/balena-cli/-/balena-cli-11.32.15.tgz"
  sha256 "f5f71e335d6d75c3d63167bcdff80ce98564cdd5adba64ab9a461e3f7eb79788"

  bottle do
    sha256 "8d146ef8d7f831e85f819c2027a8d5a35b813d806097b5f48e70a227e7bb5003" => :catalina
    sha256 "d3b2b332b2f0263dafb57472e7c2a8f6965231a5c5b7ea1337b03f78ae685057" => :mojave
    sha256 "d6ed40c7b1855d9a271e177caf5384328c1587041355d2fbb103e563943884ac" => :high_sierra
    sha256 "3648e5606d99a60ff5332ca70e1e67d7dac31de8f9599fe16a52e0cf4f8facdf" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Logging in to balena-cloud.com",
      shell_output("#{bin}/balena login --credentials --email johndoe@gmail.com --password secret 2>/dev/null", 1)
  end
end
