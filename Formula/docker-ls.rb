class DockerLs < Formula
  desc "Tools for browsing and manipulating docker registries"
  homepage "https://github.com/mayflower/docker-ls"
  url "https://github.com/mayflower/docker-ls.git",
      tag:      "v0.4.1",
      revision: "6b43cadf58018486a517274608b3fb7f857d8f62"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "87d0952201a03ac236a71b357ddcfae8e3333c6632cadca39ef4bcc4e4dc64af" => :big_sur
    sha256 "29a02c5b825f8c2484b9cf6daf9e7849de976839cf8f3846236b1603b924b6c7" => :catalina
    sha256 "09d95ecc4e15656d88b826aabc4fc4219cede111360a5679755c682d0c90d130" => :mojave
    sha256 "a4070032bdcef6700c2bf40201716c7fd517c766fd5cf64871e7b1c39f6c5f2f" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/mayflower/docker-ls").install buildpath.children

    system "go", "generate", "github.com/mayflower/docker-ls/lib"

    cd "src/github.com/mayflower/docker-ls" do
      system "go", "build", "-o", bin/"docker-ls", "./cli/docker-ls"
      system "go", "build", "-o", bin/"docker-rm", "./cli/docker-rm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match /\Wlatest\W/m, pipe_output("#{bin}/docker-ls tags \
      -r https://index.docker.io -u '' -p '' \
      --progress-indicator=false library/busybox \
    ")

    assert_match /401/, pipe_output("#{bin}/docker-rm  \
      -r https://index.docker.io -u foo -p bar library/busybox:latest 2<&1 \
    ")
  end
end
