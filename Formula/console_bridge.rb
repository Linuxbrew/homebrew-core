class ConsoleBridge < Formula
  desc "Robot Operating System-independent package for logging"
  homepage "https://wiki.ros.org/console_bridge/"
  url "https://github.com/ros/console_bridge/archive/0.5.0.tar.gz"
  sha256 "1cecdf232b1eb883b41cc50d1d38443b2163fdc0497072dc1aa6e7ba30696060"

  bottle do
    cellar :any
    sha256 "abb88e030690ad35e0be3167e4135101037ca4b841b1343f21e3b88858871df5" => :catalina
    sha256 "366956b5c93c9b0edb378017254d652d748869e5a61323331479b1d70a854541" => :mojave
    sha256 "e2a6886856f882767fcffc65826da0485130fcc8e0444a8584f2c703cc5dbe93" => :high_sierra
    sha256 "1e5cb663c2c3d6160a00835a0863e0547b5e2c56bba571316caeea7d1fbb8bf8" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <console_bridge/console.h>
      int main() {
        CONSOLE_BRIDGE_logDebug("Testing Log");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lconsole_bridge", "-std=c++11",
                    "-o", "test"
    system "./test"
  end
end
