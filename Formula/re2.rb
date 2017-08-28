class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2017-08-01.tar.gz"
  version "20170801"
  sha256 "938723dc197125392698c5fcf41acb74877866ff140b81fd50b7314bf26f1636"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "a5e367b48b0e39f779af46261614851a5d64e799fbd7e98a23ea6a3a1ee1c1eb" => :sierra
    sha256 "acfd83f1fde8c71d9eea5b5b3fe04faa00541c58f3331aa8841680749485c9c3" => :el_capitan
    sha256 "7658df57f4ee5ab781b017ff3df629c3fad1dda84527376042299923c0b481b6" => :yosemite
    sha256 "e0b5d00bc44eaf5c630858189b50c042a2e0bdb2ba21be0f616e9139ac5b92de" => :x86_64_linux # glibc 2.19
  end

  needs :cxx11

  def install
    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib") if OS.mac?
    ext = OS.mac? ? "dylib" : "so"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.0.#{ext}"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.#{ext}"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
