# serverless: Build a bottle for Linux
require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.61.2.tar.gz"
  sha256 "14c42fa84bc60e2051af6a0030dc1377ed0b42c79097b88e77729c1857e0b1be"

  bottle do
    cellar :any_skip_relocation
    sha256 "c24bff65d4bb42bea05430a26632ee21c0dcdc5d7d513f379c95fd6d38579299" => :catalina
    sha256 "5965728f6412c4f637e591360de4714186bdd61ab0bf7738cf44ff34dfc0f676" => :mojave
    sha256 "a6a7df07f83ee38fe0a5361bce6725a7411a1a51277fad34c532cc3661b93047" => :high_sierra
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
