require "language/node"

class ApolloCli < Formula
  desc "Command-line tool for Apollo GraphQL"
  homepage "https://apollographql.com"
  url "https://registry.npmjs.org/apollo/-/apollo-2.30.0.tgz"
  sha256 "91d86e0f687433b4668ef26b2d4875e33b03ee5b582dde94629b9ab87ebb4f6b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae0e5274f3062eab9788ba801e29e078b716e43223d159a56e553fe599abb252" => :catalina
    sha256 "effa666679101e11a0531d3f68a8be1ad6ab0883361a6a465cd1f4d70db560a4" => :mojave
    sha256 "82c868a04df66a8d7923d42dc01f82f4ebcd2233dc77c3286fd3e741ca48a201" => :high_sierra
    sha256 "707ee7f0926f2a45a6f936cdd24046a9c8ec355819e5a36b5e3972d385de965f" => :x86_64_linux
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
    assert_match "Error: No schema provider was created", error_output
  end
end
