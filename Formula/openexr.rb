class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.0.5.tar.gz"
  sha256 "7aa6645da70e9a0cce8215d25030cfd4f4b17b4abf1ceec314f7eae15674e8e4"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ee6c0668eb9cafb1c0138279dcbb5462fbedf34117c5be22bb723a378341af92"
    sha256 cellar: :any,                 big_sur:       "756dc00da46b56ca94fa15b5922c3eaeef492f46e11e577ed534e90abbcbc541"
    sha256 cellar: :any,                 catalina:      "b207598cda6bdceef2ec14bf86fe51b4d54bd94e6cba1370903a716a3a79287d"
    sha256 cellar: :any,                 mojave:        "3b81c48f16f627b0dfc2f02c423788ca488161df77e50533fedb660fa88c486b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba26dac93e611bda82a3bd5582ea1922e849e4ab4800473cdfb7103d3e33822f" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
