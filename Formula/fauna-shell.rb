require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-0.11.4.tgz"
  sha256 "9593dba01597c7e8f84b36c79a2b99305a7e8777aa63b575e0e873860033b33f"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ede3a23aa4ec4690edc5852b6d498b6d55a7a7b803e2e8d2680cbeae94cac48" => :catalina
    sha256 "3eb88ef49e40e98ce221081e78f941238a20283475c58a83f6ae0554572ab58a" => :mojave
    sha256 "08460537ad680455a9ceded7646a87d9c95fc75fac4db659f7c2a3bdf5b5c9bf" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_equal "fauna_endpoint *\n", output
  end
end
