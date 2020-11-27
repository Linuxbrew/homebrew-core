require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.13.0.tar.gz"
  sha256 "5ddd9e2d85ea1f3defafb54ba29ab42ec6edcb73e642a5684ccf7522281fef10"
  license "MIT"

  bottle do
    sha256 "01940facf0e14ae0e91f8bf7427dbc833d39ca825af37d227b6ba4639572d895" => :big_sur
    sha256 "6bd4e4c8eddbae3abdf94f4daaf1071c949aee158408bfee6dbae954b913e077" => :catalina
    sha256 "055a696108e63140ef34e3b7d2a9a7497c5ba07d0dbd6dc3726960c9cec18891" => :mojave
  end

  depends_on "node"

  on_linux do
    depends_on "python"
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
