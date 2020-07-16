require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.10.5.tgz"
  sha256 "7ad420ecd76539744759c60c5e118abd7b103eb19631163f1879b4a00217b05e"
  license "MIT"

  bottle do
    sha256 "97994b3ae974782537a2a0127526230470c340f88eb79115142258ca895e5336" => :catalina
    sha256 "a5b87e906beea6580a65befdd61a927bfa152bbf47698d516c211d1a8be34691" => :mojave
    sha256 "663c420051ebf322932f7c82af7b5bd7fc6269cf9eefed6b14ab5966eeff4f6c" => :high_sierra
    sha256 "a335cf448e578286ed4dc125db9eecd49688a24706910b77758f0741caf198ba" => :x86_64_linux
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.10.5.tgz"
    sha256 "cebcdfc983c5dd3c3535bd6a0ea1f2f550cb3339d76284114d51c5b3cd80d5ce"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
