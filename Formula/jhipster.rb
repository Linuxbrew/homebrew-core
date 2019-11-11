# jhipster: Build a bottle for Linux
require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-6.5.0.tgz"
  sha256 "5e1369e41c841ba66a24294e89d20962021b53c790f9d13125757ab6d3b94068"

  bottle do
    cellar :any_skip_relocation
    sha256 "42018d020aa6b235a385ae2321b0377e4f04dff5af9ac22765e2d7d298da4870" => :catalina
    sha256 "517407dc0ebc68b7ebfb7b456782edcd5ebf6d0bb7c022360213f1714c3fe8e0" => :mojave
    sha256 "a10d1fe697e85dc1376fcc1df30417a5d376a1e44e02b20fa3fca3c06f273b2c" => :high_sierra
  end

  depends_on :java => "1.8+"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
