class CodeServer < Formula
  desc "Access VS Code through the browser"
  homepage "https://github.com/cdr/code-server"
  url "https://registry.npmjs.org/code-server/-/code-server-3.3.0-rc.7.tgz"
  sha256 "22b7df81f2a5d372bac5bf5251407ca18493675ee3d50113b4d7817b711503b2"

  bottle do
    cellar :any_skip_relocation
    sha256 "634a7d32040de5e4cfe647c001c23668289b2ee547b5599819405e0b185be899" => :catalina
    sha256 "b8db069511d9b5153338be72676fe81c1da20120672089718e3cce89ab885337" => :mojave
    sha256 "621b0b114f5a914737a887fda556fd3b83022f6ec81d6f4b008d5a64d403ce69" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "yarn" => :build
  depends_on "node"

  def install
    system "yarn", "--production"
    libexec.install Dir["*"]
    bin.mkdir
    (bin/"code-server").make_symlink "#{libexec}/out/node/entry.js"
  end

  test do
    system bin/"code-server", "--install-extension", "ms-python.python"
    assert_equal "ms-python.python\n", shell_output("#{bin/"code-server"} --list-extensions")
  end
end
