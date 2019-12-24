# serverless: Build a bottle for Linux
require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.60.4.tar.gz"
  sha256 "edc21e81c2d50b05591f0ea32701e475366f2a2455df9afda9a1101c89a5b624"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ba8a47521b3df59b1662429b69efd4ab2e54fe80fbd5072af0bff9bc9e8c880" => :catalina
    sha256 "1b5e40cde44e3ed4143fc113f13a6418611ac5fc8393f65f1462d526c90230e2" => :mojave
    sha256 "cfe3b2ab62f982c890cba2caaaec3b3b47368b2b9465b391c3de640c29dc807f" => :high_sierra
  end

  depends_on "node"
  depends_on "python" unless OS.mac?

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless config credentials --provider aws --key aa --secret xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
