class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-5.1.6.tgz"
  sha256 "acc7eb2ae79b31d7e0af7511e87d5129a58ec3b65e6dbcb3c01b9928a2d67d28"

  bottle do
    cellar :any_skip_relocation
    sha256 "d83c4bae1fe16b46e903408da309f28d17f5425a6a112382caf4f7d7550cee17" => :catalina
    sha256 "ec80df6f3b9ecbdc9362a1acc71e2f34dd1082585a16211de1ff96cd2551e8b0" => :mojave
    sha256 "53b86216af2b1427ccca25f9ec0fa041fe831cd7edc2e64167e91501116ef66e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
