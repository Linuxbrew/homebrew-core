require "language/node"

class Newman < Formula
  desc "Command-line collection runner for Postman"
  homepage "https://www.getpostman.com"
  url "https://registry.npmjs.org/newman/-/newman-5.2.4.tgz"
  sha256 "cd65415463aba3c5f57e92b93e4603eab4ad823dbf3b0e960640cfdf18e417fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "21130a928c057859222d1902adfa6429daa2e34a596505bbbd304284257f6d54"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, catalina:      "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, mojave:        "ed2748b227245376f268f0d0b560fefe96b560e284acf5976068e900abfddcb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0e0f7ab473f4d5e35c5d1d1d9d5cbeee68b98a884c03cf2c1bce787e5a3eb7f" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    path = testpath/"test-collection.json"
    path.write <<~EOS
      {
        "info": {
          "_postman_id": "db95eac2-6e1c-48c0-8c3a-f83c5341d4dd",
          "name": "Homebrew",
          "description": "Homebrew formula test",
          "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
        },
        "item": [
          {
            "name": "httpbin-get",
            "request": {
              "method": "GET",
              "header": [],
              "body": {
                "mode": "raw",
                "raw": ""
              },
              "url": {
                "raw": "https://httpbin.org/get",
                "protocol": "https",
                "host": [
                  "httpbin",
                  "org"
                ],
                "path": [
                  "get"
                ]
              }
            },
            "response": []
          }
        ]
      }
    EOS

    assert_match "newman", shell_output("#{bin}/newman run #{path}")
    assert_equal version.to_s, shell_output("#{bin}/newman --version").strip
  end
end
