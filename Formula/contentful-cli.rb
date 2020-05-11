require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.3.30.tgz"
  sha256 "a113f104958f5786d4c4a746412d3b1b211004ae5b77097ac9aa1e19e2adf28f"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ff61e6eb13caa19e97765fcdf6b56694bf0d22dd3119ea589646cbacd32a426" => :catalina
    sha256 "daa96637d5ccf989f5f0b66e6f7efc1a0344b7c42f22b83ae2736d55c64bf7f9" => :mojave
    sha256 "9559dc892145a25868a31dab81424b64eaa9e0649eaf2eb3df166a4538b98b2c" => :high_sierra
    sha256 "47516635a3cdfb5fef902a9a396623dc76dedd93f14b5c4ce773e9bf97dace48" => :x86_64_linux
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
