# jfrog-cli-go: Build a bottle for Linux
class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.30.1.tar.gz"
  sha256 "f9fa7c8fbf98753a745afbad989dda37ac63d96920d0a51f62d4ab8613623510"

  bottle do
    cellar :any_skip_relocation
    sha256 "95c8ca4683a3373eef7c1a12d1e788b54da4372ba44e04b264153038b6b18613" => :catalina
    sha256 "ff147796927e81337f50e3d3ddf9f9cd3f25aac19e7b4806f8359e72ba7e7e69" => :mojave
    sha256 "4eed8990d3e1b7be980ac39d8fa30692b1c72ff24342e6048ec0eca8d2b4abc4" => :high_sierra
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
