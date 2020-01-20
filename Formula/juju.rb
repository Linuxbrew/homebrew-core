# juju: Build a bottle for Linux
class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.1/+download/juju-core_2.7.1.tar.gz"
  sha256 "275e224d2f109d86744a681a1eb1e66244f190497a720b4202c197281c97f3ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "6fc00d0c8ec569c96296a7cd8a8a6e78ecc932f6890d491c064afa44b40b4839" => :catalina
    sha256 "8c60c827f11457067daa579e7e636e0ceab0bec642f179a6fefc24ab2f31f71f" => :mojave
    sha256 "17fef1ce6bfdd31955176d51ba777e070eb97667d8684f42460e4bf17063075a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
