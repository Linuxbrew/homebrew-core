class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-07-06.tar.gz"
  version "20200706"
  sha256 "2e9489a31ae007c81e90e8ec8a15d62d58a9c18d4fd1603f6441ef248556b41f"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "9488f23044e3dac53037c0906aea59a387d2b71ccf43e376c20f704777348405" => :catalina
    sha256 "d5af261e2d489687f238d7b6458398802439e1318d2126b43916e122c10a89ff" => :mojave
    sha256 "e4b42769e4c2e9b2340a0524942a8a98012c20f06896b2bfbeae076775043bcf" => :high_sierra
    sha256 "15530a383483295899861b00a32b151695b6c709c94e93757052c850577000c6" => :x86_64_linux
  end

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <re2/re2.h>
      #include <assert.h>
      int main() {
        assert(!RE2::FullMatch("hello", "e"));
        assert(RE2::PartialMatch("hello", "e"));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11",
           "test.cpp", "-I#{include}", "-L#{lib}", "-pthread", "-lre2", "-o", "test"
    system "./test"
  end
end
