require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://serverless.com"
  url "https://github.com/serverless/serverless/archive/v1.75.1.tar.gz"
  sha256 "aacb3804e2e20ac6a485b64a85110d05138cd4733c768922cd8aac46c2d0ce5c"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d07c2de6b02992ae0d6529ee92d8caca549d998ce49b1a39cf364dfbbecdfd5" => :catalina
    sha256 "2132ae3310cfc3dfcabaafb44218b8ff9cb6bf05e982362e2a11e82e4d124816" => :mojave
    sha256 "269bec22d0a3442859504618974580190293f94df0cafac64e5108c215a9c284" => :high_sierra
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
