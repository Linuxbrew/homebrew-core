# serverless: Build a bottle for Linux
require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.59.1.tar.gz"
  sha256 "008bfa1d2eb67d80d1e248f2f6dc625d520652d15bf09fdaab0923c7a522c6c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "384e268a59eaa8eb5c00da84867bfd67ae1426e0c83ca5c5450496ce5ca8f48e" => :catalina
    sha256 "08681caa7c609853f46e13f97053d0ff7049d52549e5720aff18227d76031807" => :mojave
    sha256 "963fed95c8194dd4c09e1fb1e0922d894b01ee26403ec66a258feb618add6bde" => :high_sierra
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
