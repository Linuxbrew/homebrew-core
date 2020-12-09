require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.14.0.tar.gz"
  sha256 "77c8a6ab34ea755a0db0e4e2c50a66a209772b4f2f2fb7a7307375f8c0f91fdf"
  license "MIT"

  bottle do
    sha256 "6927209faeda1bb6eb6acbd64a2addbd2413512605be0b57c83dde766f377452" => :big_sur
    sha256 "29540876851d057de651054b007669062407665393899ca2aae7780c5f26104d" => :catalina
    sha256 "5ec9a81c989a45a73bb93301953f80bd0ff73a4b778397cd313238f56dc233c8" => :mojave
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
