class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "d43aa851dc9a9f1a1690f02831b31401b5d0abde5710c5c7c9c593e910597fc7"
  license "GPL-2.0-only"
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c0c9b7262c31549a6024d45ff408a7eb4ff4cf6c1df9f24ed7b6cc397158f6a4"
    sha256 cellar: :any, big_sur:       "497ce8851d225061de1abd4120771dba40a1e40aa3bd1c48cf4999a61b0e25ba"
    sha256 cellar: :any, catalina:      "4b72b74dadb031d1803aa7bdb158485b789520dba40ddcbacb5b71222f47aba1"
    sha256 cellar: :any, mojave:        "bdd59841651992bc5967276ddfd16fcf42289204e267c8f43576c2f0337a0852"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
