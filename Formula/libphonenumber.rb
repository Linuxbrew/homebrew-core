class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.27.tar.gz"
  sha256 "4695831c8a3ffb0b164121874fe423fcf2c4b4bd60da7b99fafd074f52cb0a1b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "b5e7e98b5c14be262ad9f86f9d2f4957201a1e8fdceb55e1b254204bf21cc0f2"
    sha256 cellar: :any,                 big_sur:       "e25778e718f8bbc644196268b505f0e57a9e2ed5e8f90a517e290dd215702ef5"
    sha256 cellar: :any,                 catalina:      "f5b285d01d8ad2cae9a573cc0114cfb366252c3ee4712aff1d9e19ba750d3f42"
    sha256 cellar: :any,                 mojave:        "8b2eec4022776c8056de183a685cd6c4581e3caf162303d09deb033dd496b583"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7aa68398e6e3812602a3261e193f3a8e2dd530c5615abb8ae64909def8eaf9a0" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  def install
    ENV.cxx11
    system "cmake", "cpp", "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].include}",
                           *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
