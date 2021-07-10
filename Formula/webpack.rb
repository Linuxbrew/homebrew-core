require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.44.0.tgz"
  sha256 "b1cddd0c7e5f9cd493ed9079bd6aa33a1d0ef007878c49a6d4ee062806198d5b"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f9d745fb42cd817d72aa82365df1246c1c4ef2eccfae3e8885f7b60fd4f59fc3"
    sha256 cellar: :any_skip_relocation, big_sur:       "ae914e3e5467e6d240f3db9aa00f9f07c5e71a6a7c4da7486ebe5c0738a39496"
    sha256 cellar: :any_skip_relocation, catalina:      "ae914e3e5467e6d240f3db9aa00f9f07c5e71a6a7c4da7486ebe5c0738a39496"
    sha256 cellar: :any_skip_relocation, mojave:        "ae914e3e5467e6d240f3db9aa00f9f07c5e71a6a7c4da7486ebe5c0738a39496"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7705a2f0010e6137e66bc14c9cda67ca23305dae3b9e1e2126f8bd900fd4ee2" # linuxbrew-core
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.7.2.tgz"
    sha256 "dce6cce3002e13873a36fb2c31034d9df20f4c68e3edecb93b9e4b71d2e32b77"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
