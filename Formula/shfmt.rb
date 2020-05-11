class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.1.1.tar.gz"
  sha256 "db5d86d9caeb025e41307cb834b21d7a35e171afe5257277e74cb3e44a17ae00"
  head "https://github.com/mvdan/sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9df4c93f70e9b4f188e01708581df840f307892b8108d03aa112c079a4a8574" => :catalina
    sha256 "8db6d076e017a6457a996f83c50a50fc12e83ce9a203a39c9288418230142873" => :mojave
    sha256 "75ba43415d9d77fe4dfd091bd8888f632ee94fcedf32e5141855cafefdd8333b" => :high_sierra
    sha256 "125cb41a9ae247eef137658ec1c06d8edb0143d3956fd2883b45fea217acd933" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
