require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.16.1.tar.gz"
  sha256 "b3ca46e792c2fcef24e94583b70f299c4ba67b8770e5ded7d9b28b90f0f16589"
  license "MIT"

  bottle do
    sha256 "a0659cfde7d73e4bd859c37191b9b003b3bf633e62d1ae8d1b0f6fd8cd6810f0" => :big_sur
    sha256 "de78d07871e8d7aca35def658da29a079c20a19c08a5b4632e619c5b4c3191a1" => :catalina
    sha256 "e5eb7a13334512d5b8695160f63064e54cefaca9183216f5372f065a55f4f45d" => :mojave
  end

  depends_on "node"

  on_linux do
    depends_on "python@3.9"
  end

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

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
