require "language/node"

class Snowpack < Formula
  desc "Frontend build tool designed for the modern web"
  homepage "https://www.snowpack.dev"
  url "https://registry.npmjs.org/snowpack/-/snowpack-3.8.0.tgz"
  sha256 "d6bcf8945c22ac8c5894c81e7f2498f8ca94fcfac7f4b823295aa11b6e500d39"
  license "MIT"

  bottle do
    sha256                               arm64_big_sur: "0bd5deb8654c73ca1c5a8a2f1a81a31d695c4194a4978ef6268500d3b9230039"
    sha256                               big_sur:       "8b402108bf4fd23aa5af95c109a3948bb8f59edd5294617fcca8010ccefb31d2"
    sha256                               catalina:      "429f76f8b69fea46562aa2f3d5a901416516f0d2db6f2c431f2473f3bc0e6ee0"
    sha256                               mojave:        "c281ae5b29f9a6b48dee884c2fb46e17c68dda31d914ef1ea6a0c1c19befb2db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6b5c9d01b1aae29f5b988d3f6af76952b8418573f0cb3ae7065101a0e3329d4" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir "work" do
      system "npm", "init", "-y"
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
