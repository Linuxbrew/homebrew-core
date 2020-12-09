require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.10.0.tgz"
  sha256 "a94c2bfea7fed07536e6ea32d22307da40dec28caf3fdfffe1d8dd0f0afe6c51"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "a91b2ae2e52554be9cf5532da3411a5722668cc1a2fe81c9f8c99d5092836ce5" => :big_sur
    sha256 "93c77a5ef6bfa94021e9b939b81d3e2c7edadf672faf49040ae66436a67d6f5a" => :catalina
    sha256 "7efbc8e4b0de54d245298b535415e64ebdc676571f438c29f65296d9d373f4d7" => :mojave
    sha256 "846acab45cbabe65aeb5a854847c7b88a891fbed84adb2beb27262ff7c45ea27" => :x86_64_linux
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.2.0.tgz"
    sha256 "09ca2de6deee939a4a2f8edf206a776caafb6fe3590ed1a8310a3e3b69ad4a18"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
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

    system bin/"webpack", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
