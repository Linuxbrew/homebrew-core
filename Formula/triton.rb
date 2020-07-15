require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.10.0.tgz"
  sha256 "bda624f459cce4e3d9b8557270a3de6a375fd181151acc3f0d0d0962b60fb307"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fc3b2c8389ebdfa1cb9e3bebe5d1a2be854bbad7ea1a244c802a00dd2fa44bd" => :catalina
    sha256 "126492ee85adc820c3d6b2fa1ab8a4b74d8446df287d7bb881472cf58909b3b6" => :mojave
    sha256 "7470699caad1f183221b1fd5be532a43662bb2dbbd06639d576bc1ffeca58967" => :high_sierra
    sha256 "fb677065bc54564e4fe885641fbb07e91b80bbdf17adfcea69b47808e9c16e15" => :x86_64_linux
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    (bash_completion/"triton").write `#{bin}/triton completion`
  end

  test do
    output = shell_output("#{bin}/triton profile ls")
    assert_match /\ANAME  CURR  ACCOUNT  USER  URL$/, output
  end
end
