# serverless: Build a bottle for Linux
require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.59.2.tar.gz"
  sha256 "4302e7ebdc6418cc1e23f2581b7bf6c6f0b9c4a7814d0fde34eb47e1af02f2ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b46d8ab058ef555d74f577aeba75d7f720275eb1d66653a178aa206a0f31eff" => :catalina
    sha256 "4ea4623092b00917b237061f6df1a397cc6a41091aab40d41b52c7134e31e248" => :mojave
    sha256 "177d6c18fef0164e94f1f871b10827569058d900d5c2662f2ce7b1fdf82ef2c2" => :high_sierra
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
