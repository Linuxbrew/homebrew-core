class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.6.1.tar.gz"
  sha256 "2408e1662f2d4dd1922f00a747090c13ee8aff561123bdc86aff9da77b3ccf74"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    cellar :any
    sha256 "506e7fc2898863823d8b481c4c89e782d6b82624b5fef6284181d502dce2f4a3" => :catalina
    sha256 "15b623c6dce054c5529940a152c4037b5821a50cee7d66b5b3ea78726294792a" => :mojave
    sha256 "764379ab8e66240539d5a7c057313887ef56ee26d2625beb44eab481ba9762a2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glfw"

  def install
    system "make"
    bin.install Dir["bin/*"]
  end

  test do
    system "#{bin}/glslViewer", "--help"
  end
end
