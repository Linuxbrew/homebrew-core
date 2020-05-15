require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.6.tgz"
  sha256 "5a999d3c0832e9363ebaa3bf8d2f8f9ef872efa339df9d070592a298916cf323"

  bottle do
    cellar :any_skip_relocation
    sha256 "44a85dbd0616e13a9ffc1ab20c8cf15ae9fc2dbc35f17a60b5553cb734af60a5" => :catalina
    sha256 "fec7928ea5aae87780c86942a4d5008a5aa337e3252849a06e2d2f08f465420d" => :mojave
    sha256 "9d0d196920b5ad1f01778b5baaa6a26bd91a35185bd449636c9a33085ed936d2" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
