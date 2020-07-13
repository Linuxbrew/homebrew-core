require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.8.7.tgz"
  sha256 "04acda3824a0dc67e92e5fb6e9d65f28e7635148b9dc270297cc8ee3c64e106a"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cf2becd23de2a545f593d4af6bba25880d862408364a8badb37d90981b854d55" => :catalina
    sha256 "86942f8c8c0781ab5d36571960bbbff81314e749e6b861fd62ed5365bd4280aa" => :mojave
    sha256 "6ce2e9e3513bb66d823c893023bd50e4c702c6310edc0b55ee1673bcbaf0b92e" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
