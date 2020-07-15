class KdeThreadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.72/threadweaver-5.72.0.tar.xz"
  sha256 "0fcd0fe46e8d2730986034b76b73fc1ecf4ae78f1796c6d5bc04a57ade0e20e9"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 "acf936c2df151adceffc6f2acc28a59e3664e6de345c8dec38ce8b7375b1adda" => :catalina
    sha256 "5c65c3b8e4abd38359c27a383f34448b3143c1ee9ef2c3d551dc6cf157394c30" => :mojave
    sha256 "5e9a3beb252a9433daa21032d9e07e33b85a518ebfeb08bee3a9b6042f832b7d" => :high_sierra
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "kde-extra-cmake-modules" => [:build, :test]
  depends_on "qt"

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
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
