require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-10.0.3.tgz"
  sha256 "dc3a7a2b90da92ef63fe84cb69b289cba09de734565b7f0354e67533d75fd801"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "235efa78d8ea21fe1620e699500fa80bf337fb7d12feebb8722418685427e7c9" => :catalina
    sha256 "ec61ea15f51c75a0eb7e25b9dc0ae1972bf5c07105162f61d1a9dc3335488332" => :mojave
    sha256 "968ff7a164a73fd77eddb5c78c5d980d79c17c7c2fd5bff3039520f8e59c3b35" => :high_sierra
    sha256 "5255b84d3483e5a2ddc0d9d18368f2afc202f30696354960a5ed956fe3c9abf4" => :x86_64_linux
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
