# jfrog-cli-go: Build a bottle for Linux
class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.32.3.tar.gz"
  sha256 "ece78de9597b6c1865c58e4f7702e8dab4eb5afec3ed279f57058930206e57c7"

  bottle do
    cellar :any_skip_relocation
    sha256 "093d20c756b029ef24c051bf9b79df2e8326db12051ed9ab07b66ad1d41669cd" => :catalina
    sha256 "515ffd4c1f3856031c6ec79db292be3c1e10a50291f765dd1c36b804bf78ddbd" => :mojave
    sha256 "2712430aa5c5a648c3ed29f51dab24c312e8987d5fe50598aaffd43b96f05697" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "run", "./python/addresources.go"
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
