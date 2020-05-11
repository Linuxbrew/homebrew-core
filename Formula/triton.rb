require "language/node"

class Triton < Formula
  desc "Joyent Triton CLI"
  homepage "https://www.npmjs.com/package/triton"
  url "https://registry.npmjs.org/triton/-/triton-7.9.0.tgz"
  sha256 "bf102ca619a0a0e6c60783d1ee87c9e475e8cd1561f2d44f794b0177264be599"

  bottle do
    cellar :any_skip_relocation
    sha256 "21d5112b9f248c6a305953dd5cd3d2295baacf8b8c19fc247a10889ede4265ce" => :catalina
    sha256 "45a55e0e4e85d81fb6a731778a418b82b543ad23e193b43ee466f79a91fe2468" => :mojave
    sha256 "ff03483801c0896b7a147ca42204208a70b846c97f16dd30119f2c8c96ebc73e" => :high_sierra
    sha256 "70f173d42692dde93dc832d9c2d01ce0a7eeecc8bc96559059518249c7665215" => :x86_64_linux
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
