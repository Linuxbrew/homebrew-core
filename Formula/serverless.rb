require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.67.1.tar.gz"
  sha256 "f2f99c0ccc04bd3183bc6b05615a79eb5ae2eab5a686113d4e0b2481ba74dfb8"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ca2e10add0adbd59d3c093cd251abbae310ec55dee7a88f095c596a790a0c5a" => :catalina
    sha256 "347959f0ba26b60f059b85d16c8aa57c16294b03b7a57641654082a8d43b5cc1" => :mojave
    sha256 "7b7e294686db11dd636561cafa99b5d727b1568031d8b315b16e0f6b7caefa6e" => :high_sierra
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
