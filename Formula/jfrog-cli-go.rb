# jfrog-cli-go: Build a bottle for Linux
class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.31.2.tar.gz"
  sha256 "a847556ff171475d661329c2e71c3f61774da2ff2f0418fae7d16f5dbed4a70a"

  bottle do
    cellar :any_skip_relocation
    sha256 "81e780ac71a8a888087e59d80d85303328f6a947d3248ed80d97cd05ce6669f2" => :catalina
    sha256 "33bdae09e643c298a4725ddcde2cddeba75ab3b15bb6d60325544395a8bb621b" => :mojave
    sha256 "e4f69ad52986f1381d390d777c5ff73c47c2ec8714b1022285abd29498419991" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
