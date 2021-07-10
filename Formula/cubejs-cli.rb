require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.48.tgz"
  sha256 "00f03411bdb9156245d614dbcbebb0a7e06df7a399a558c5ce3fb927a7027d06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "46afa0852d343a53973dc912b597dc2f1ae5a48f5fe1a5b4adcb4f40fad5b86a"
    sha256 cellar: :any_skip_relocation, big_sur:       "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
    sha256 cellar: :any_skip_relocation, catalina:      "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
    sha256 cellar: :any_skip_relocation, mojave:        "6226565c18bc3fe6ea61476fb5fa3697f44fcda304a49e0ed785d0226509791a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca648686a81a08936fea38ef102839d920e100475e2ca04f629ff402e2b0eed4" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
