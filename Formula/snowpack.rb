require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.1.2.tgz"
  sha256 "0aea9c6146a63da547ec3cf09099aed9d27aee3a7bcb35c95177dbc2d23cd497"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3df96ce4800dc5bdbfff3335939e52a262944233daaf812ea6740dc96dbc51a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "fec5e8d8a249a51f14a7f1e1c911ca8f0f370c86f0aae483d5968422606c45f5"
    sha256 cellar: :any_skip_relocation, catalina:      "696fa879a214092c47a5f6e64b1f24d1f9796db512be77e359b5f5747a030f0f"
    sha256 cellar: :any_skip_relocation, mojave:        "15a145271992199791230f71cbbef4aa0a778c3e876a746c736d62ba26cfad31"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system bin/"snowpack", "init"
      assert_predicate testpath/"work/snowpack.config.js", :exist?

      inreplace testpath/"work/snowpack.config.js",
        "  packageOptions: {\n    /* ... */\n  },",
        "  packageOptions: {\n    source: \"remote\"\n  },"
      system bin/"snowpack", "add", "react"
      deps_contents = File.read testpath/"work/snowpack.deps.json"
      assert_match(/\s*"dependencies":\s*{\s*"react": ".*"\s*}/, deps_contents)

      assert_match "Build Complete", shell_output("#{bin}/snowpack build")
    end
  end
end
