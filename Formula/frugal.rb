class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.10.tar.gz"
  sha256 "1d9280167e00cef68bf195a3b539c576bc3937bdaf8e6fa2367ef5a80d0a001c"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "da1d952cef624e978e666eb5274bc4dbf96aa0048ef9e18152cab44093327ba5" => :catalina
    sha256 "7f705a8da2de66cb9ab3eaec6984eeb7bf09ef631420d6eff59a1cf5c49092b5" => :mojave
    sha256 "5d60462a277965e5181b5350df91b4eb3eaf9c34f4d7b902e7328067adaf8034" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
