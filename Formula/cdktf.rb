require "language/node"

class Cdktf < Formula
  desc "Cloud Development Kit for Terraform"
  homepage "https://github.com/hashicorp/terraform-cdk"
  url "https://registry.npmjs.org/cdktf-cli/-/cdktf-cli-0.3.0.tgz"
  sha256 "9de75547d30ef2e19b7e700444e7f9ef41466589cc365f860a9a3f27b10ead4d"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a0bf8e63f821acf34ae121085deb186442cb227e510e0ed79a9138e60c975e00"
    sha256 cellar: :any_skip_relocation, big_sur:       "86af5928c4bbc02bb02a9eff1d7cabe2bec0b8024cfcc36011bd014727beb7ee"
    sha256 cellar: :any_skip_relocation, catalina:      "86af5928c4bbc02bb02a9eff1d7cabe2bec0b8024cfcc36011bd014727beb7ee"
    sha256 cellar: :any_skip_relocation, mojave:        "86af5928c4bbc02bb02a9eff1d7cabe2bec0b8024cfcc36011bd014727beb7ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12cbbd71f285c2ac63e2874df5076105ac821b7cc28ddb320761d5657fe0e479"
  end

  depends_on "node"
  depends_on "terraform"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ERROR: Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdktf init --template='python' 2>&1", 1)
  end
end
