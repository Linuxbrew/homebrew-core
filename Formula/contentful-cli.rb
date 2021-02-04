require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.5.15.tgz"
  sha256 "03b8146cdc28ba8cb2fa8564a65d26e5cf660e987f8fbb50954fc12346245485"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b58ebf1fd5ce935695403761bd5ca1f07f90af99855f02d02abbbda0346b81a"
    sha256 cellar: :any_skip_relocation, big_sur:       "c58c39ec09d1c7f8ee3f33f630c973b9130eb81fa85248861a443c820d9df0e7"
    sha256 cellar: :any_skip_relocation, catalina:      "09700be6d19118704b3d234e497811f419284da934ee6960c3501fd7f2fa1cd4"
    sha256 cellar: :any_skip_relocation, mojave:        "5444fb62c4cdff96a9f01dda09b4ffb12b19033f600beb8596a4c8aab7ff568f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93710c50f96150caf67a19c6e7a97b3534ff17b889fa8309e4e700503c7d7ac8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
