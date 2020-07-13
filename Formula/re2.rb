class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2020-07-01.tar.gz"
  version "20200701"
  sha256 "116c74f4490b5d348492bc3822292320c9e5effe18c87bcafb616be464043321"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "8bc4b0cf696adeedc101731d1c362785f0e0a91f740b87beba0cff589d6082f0" => :catalina
    sha256 "2d57f1f245f2f94728fe6b305d724e22928a92f580f8a12b334737287c6aafcd" => :mojave
    sha256 "4afe221faf13b3cc35165e59ae7f8ab6b541b4559fbf2a363691479c16a5a6d0" => :high_sierra
    sha256 "8c107f247e4ebd4cb11f01676e6b91b7b0f16043e6535a247cfc8447594ae8f4" => :x86_64_linux
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
