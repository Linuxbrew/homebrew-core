require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.27.4.tgz"
  sha256 "56bc7c47532c3aca1bb3d0523bd1447b1af9ae0b68693f3745707ebf8f612783"

  bottle do
    cellar :any_skip_relocation
    sha256 "6bda5c2e2dccf598de82de00ef5b54f0a6e3d657b4abfea826f436668c17d081" => :catalina
    sha256 "d6c026f9573682c70d1d9268181cb2f76c02db478107934c4b401c039bc6a9e0" => :mojave
    sha256 "b0ca2084323310a7052f724bdf919a28b059747143bcf79facea757decdfda19" => :high_sierra
    sha256 "62196e7d1e90e1c596732adc9b744be28a98cf90849212045f3849057342f487" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "apollo/#{version}", shell_output("#{bin}/apollo --version")

    assert_match "Missing required flag:", shell_output("#{bin}/apollo codegen:generate 2>&1", 2)

    error_output = shell_output("#{bin}/apollo codegen:generate --target typescript 2>&1", 2)
    assert_match "Please add either a client or service config", error_output
  end
end
