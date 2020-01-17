# doxygen: Build a bottle for Linux
class Doxygen < Formula
  desc "Generate documentation for several programming languages"
  homepage "http://www.doxygen.org/"
  url "http://doxygen.nl/files/doxygen-1.8.17.src.tar.gz"
  mirror "https://downloads.sourceforge.net/project/doxygen/rel-1.8.17/doxygen-1.8.17.src.tar.gz"
  sha256 "2cba988af2d495541cbbe5541b3bee0ee11144dcb23a81eada19f5501fd8b599"
  head "https://github.com/doxygen/doxygen.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e616dc31b1fa5fc8e4f1ff3102b049cfaa2e13f199de9e06123d4dbe33a75790" => :catalina
    sha256 "609bb888081320306742749bf91f4cfd17815bc8d3d4385ebe25932d1d97302e" => :mojave
    sha256 "a1054bedac664bf5edbcebd74606d6e67cb8cc8c64871206fc93728cca02d1e1" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "bison"
    depends_on "flex"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=#{MacOS.version}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
    end
    bin.install Dir["build/bin/*"]
    man1.install Dir["doc/*.1"]
  end

  test do
    system "#{bin}/doxygen", "-g"
    system "#{bin}/doxygen", "Doxyfile"
  end
end
