class Libebml < Formula
  desc "Sort of a sbinary version of XML"
  homepage "https://www.matroska.org/"
  url "https://dl.matroska.org/downloads/libebml/libebml-1.4.2.tar.xz"
  sha256 "41c7237ce05828fb220f62086018b080af4db4bb142f31bec0022c925889b9f2"
  license "LGPL-2.1-or-later"
  revision 2 unless OS.mac?
  head "https://github.com/Matroska-Org/libebml.git"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1fc990bad774ee2d7ce5d0794effee2529fbd31932854f2a6aa444d8634ce821"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
      system "make", "install"
    end
  end
end
