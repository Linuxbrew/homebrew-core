class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools.git",
      :tag      => "3.0.0",
      :revision => "dbd4ef8997abb3a7bef0ba4867caaf206db86b6e"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b8e9111679cf1de6513a7213b048705c103b3303f04bbb3820bede952b96b2d" => :catalina
    sha256 "9b8e9111679cf1de6513a7213b048705c103b3303f04bbb3820bede952b96b2d" => :mojave
    sha256 "9b8e9111679cf1de6513a7213b048705c103b3303f04bbb3820bede952b96b2d" => :high_sierra
  end

  depends_on "bazelisk" => :build

  def install
    system "bazelisk", "build", "--config=release", "buildifier:buildifier"
    bin.install "bazel-bin/buildifier/darwin_amd64_stripped/buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
