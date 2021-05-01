class HowardHinnantDate < Formula
  desc "C++ library for date and time operations based on <chrono>"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v3.0.0.tar.gz"
  sha256 "87bba2eaf0ebc7ec539e5e62fc317cb80671a337c1fb1b84cb9e4d42c6dbebe3"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "00fa553068d96aae84e643633ca7c8b83f93db7828a120ae2002c1aebc0c3e77"
    sha256 cellar: :any, big_sur:       "f2af75c2ead585048a5321ee123521a95c6cafa35f5d8d0a1838d30924eb6361"
    sha256 cellar: :any, catalina:      "336157e546ea77db5ec3c0360b4e873e8c6ec265aa6dedb2fe19d45a6df207fb"
    sha256 cellar: :any, mojave:        "20a35158d9c478a553baae673544620546db6f31825f9e052a0bbf07086e773e"
    sha256 cellar: :any, high_sierra:   "f23b72ea88d5c0bc12f2e93dff65ba6a9867d88831294fc5c770f2d0a39762fa"
    sha256 cellar: :any, x86_64_linux:  "22c1c286e4ca22f4aef885239fa19ce328d683bd6a0d53ae8b06add94b26c5b5"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DENABLE_DATE_TESTING=OFF",
                         "-DUSE_SYSTEM_TZ_DB=ON",
                         "-DBUILD_SHARED_LIBS=ON",
                         "-DBUILD_TZ_LIB=ON"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "date/tz.h"
      #include <iostream>

      int main() {
        auto t = date::make_zoned(date::current_zone(), std::chrono::system_clock::now());
        std::cout << t << std::endl;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++1y", "-L#{lib}", "-ldate-tz", "-o", "test"
    system "./test"
  end
end
