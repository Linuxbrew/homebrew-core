class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  url "https://github.com/openexr/openexr/archive/v2.5.2.tar.gz"
  sha256 "5da8dff448d0c4a529e52c97daf238a461d01cd233944f75095668d6d7528761"
  license "BSD-3-Clause"

  bottle do
    sha256 "cd7b32d91f6e70711a4010f2027be140189d8fc92f5fcdb12331228a9e762817" => :catalina
    sha256 "057ebb08dfa17cefc33121b6fe39af3ac43b59b4c197abba473a0e4724f07802" => :mojave
    sha256 "a5d9520a67acdb84ac3593290d2d65d3f4dd0c4db4ed4fe9f5c07c4b5a441ae2" => :high_sierra
    sha256 "72c03bb0e75166c7d6328cc01831dfcdfe49c4fc1c699b4ca2232c8b6784f276" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
