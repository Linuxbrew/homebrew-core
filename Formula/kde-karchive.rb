class KdeKarchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.72/karchive-5.72.0.tar.xz"
  sha256 "d1857451305bbc06c2391f1be2aa59836291910391f4f26f243e8f038a47ef5a"
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256 "54e816adb054461eb004a484baf6ab29d201e1dec85309b7c2ed4dbe04cd6863" => :catalina
    sha256 "4a4773abfbe0af53b760cdc5f6f459a47652c5b1d87bac81c6ae5f1232bb09ec" => :mojave
    sha256 "98b2171ec9bfd30ef828e95b63b2ce737f7b04aaefb6fa0c0ed837de167f06e3" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]

  depends_on "qt"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
