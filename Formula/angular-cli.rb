require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.0.3.tgz"
  sha256 "19c317626cedb70d6651c3f0efe7ff42defec757d520c84a9cf6679ba2e8de96"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d62ef84298c88d47ccac828110b93eb99bf021115039a2078794c2e16799fea5" => :big_sur
    sha256 "5900fc4a533587147ff84d5483827f7fc53061b9af98a991adf223e748e72a36" => :catalina
    sha256 "7b3241629f44c1ebb020cec6f9f4e377a6ce71b051fb907da43933c5c0c42d92" => :mojave
    sha256 "a6787a3ee4c8e5ff233e01dfdd0e5894844281086c561b1ac0cc82abb8d5cc90" => :x86_64_linux
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
