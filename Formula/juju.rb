class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.7/2.7.6/+download/juju-core_2.7.6.tar.gz"
  sha256 "5497bcdd61cb46c7b6ece8ccf939b99c78a3ea6c234854d0e4bfae229a7c18bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5e2dfb9c61ad71bde7cfa9fbea7b332929a7a17bcd9c5572862c6c72ec68ccc" => :catalina
    sha256 "c403a83802d6bd52a3cee90be7ca5235683b5c7fdcf67b0a39905db4a53023e3" => :mojave
    sha256 "d55865d9e9ae6cdd35225a4dba3e869f5380d7b73d9ae02eae4331ba439738d3" => :high_sierra
    sha256 "042cc7a0155ef465979f6bef51fa4c198c1d168d52a8869910d02e79dbeed59c" => :x86_64_linux
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
