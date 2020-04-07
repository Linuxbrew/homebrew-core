require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.8.tgz"
  sha256 "05093e07f9dc3ddbd104b3c88eee9618fc1ba5885bc739940a9c989a7a73d45a"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ee123ac49ca307977e3b8812e0c61a741cb64ee1bfa669d0317d8d831dd35b61" => :catalina
    sha256 "218eb05b5a3dcb68cf4ba64f45c774943a5eacf4376ba5b84845f3b4f2da9436" => :mojave
    sha256 "c4af55f0e388882c4390f7bc14094a5ba9848c5f4365c96d119a2f96f5c53fe0" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a managementToken via --management-Token argument", output
  end
end
