require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.1.3.tgz"
  sha256 "75b0a073a9b9df1130d9ff93d00d06ff3342ed90e153ab0fe645261c7348c00b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "3290f2a4ccfc9077686c14c5ec9a91654dcfd272d1f2856e44f963bbcdbf79ca"
    sha256 cellar: :any_skip_relocation, catalina: "ae8d9579277f036bdb366ce9d1e67693794f05af69c2fb0943eb3d82d0a447a5"
    sha256 cellar: :any_skip_relocation, mojave:   "e48afb8c6bf5b12ecc0774441aa806cb098205643bb3dd9eeb61b828935c4c63"
  end

  depends_on "node"

  resource "petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--nodejs",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
