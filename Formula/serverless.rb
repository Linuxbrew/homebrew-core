require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.70.0.tar.gz"
  sha256 "95a0e21a8a60195ccf803c8cbe9f6b8de71938e395f592caacf352c4b7e55834"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbc9658c231e26c473a0a756ba20736b868e666a62155ab60e3782b5e6e4c14a" => :catalina
    sha256 "54368e529d9bbefd2e717d9eea5f16739314f824282f07e23e2b9b0eec045cc4" => :mojave
    sha256 "a9e66d154c58778bcd75c174755dd8e813a75be8448fe052529c5e6f5ae492d3" => :high_sierra
    sha256 "9ca769560de21eab285e323d4deb010e14a194ba725ce85cef5bf0399b5db71b" => :x86_64_linux
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
