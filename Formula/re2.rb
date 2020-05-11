class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-05-01.tar.gz"
  version "20200501"
  sha256 "88864d7f5126bb17daa1aa8f41b05599aa6e3222e7b28a90e372db53c1c49aeb"
  revision 1
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "24de88e2c4a0ce890de51229d017c2d95920e60da5b156f52732ff1eae81340a" => :catalina
    sha256 "02ab50a96b2b1deac2a7175fb1974563c06c9fe38d824147de837dfd0add601e" => :mojave
    sha256 "265c167a79095a8902a9bc072e5765e6092780be07dc6d0ddc5f057198e1570c" => :high_sierra
    sha256 "923c2b0132eafbab5f68317104a42c4814a063dd4111c3a6fdf166f2d5560c2d" => :x86_64_linux
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
