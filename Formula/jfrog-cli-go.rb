# jfrog-cli-go: Build a bottle for Linux
class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.33.1.tar.gz"
  sha256 "0960f073991dd2e754ee3809f6c371529de90399f2acdfc3c507dbdc9717d1e6"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd249060d9f2cbbba924e9ab02af1f1abceef870bf054c71e46f3c5655f7da76" => :catalina
    sha256 "0b4d20294f2eac3562ff1269ea57216e6b667b0729ccda1ebd9dd85bc94e8c02" => :mojave
    sha256 "ddda26b5227e19af50d9ddaa1eaa8faaeb699156b8cf661e09d1a52fd66d3a3d" => :high_sierra
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
