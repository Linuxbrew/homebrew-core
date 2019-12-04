# fmt: Build a bottle for Linux
class Fmt < Formula
  desc "Open-source formatting library for C++"
  homepage "https://fmtlib.github.io/"
  url "https://github.com/fmtlib/fmt/archive/6.1.0.tar.gz"
  sha256 "8fb84291a7ed6b4db4769115b57fa56d5467b1ab8c3ba5bdf78c820e4bd17944"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b20b99f2b7e85fe02959db7fe2cfc7acd4bf8f679f5f0788a4c8efca6a8133e" => :catalina
    sha256 "3938ea463364b15d2e1c34389d1a4ef913de230a37555e9f6b193148c4a25a66" => :mojave
    sha256 "1a8b8d6e8e3f323cfd7b6d8d45468895fb89609e4fd593ff731aad2527abc48c" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <string>
      #include <fmt/format.h>
      int main()
      {
        std::string str = fmt::format("The answer is {}", 42);
        std::cout << str;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test",
                  "-I#{include}",
                  "-L#{lib}",
                  "-lfmt"
    assert_equal "The answer is 42", shell_output("./test")
  end
end
