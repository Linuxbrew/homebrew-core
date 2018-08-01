# re2: Build a bottle for Linuxbrew
class Re2 < Formula
  desc "Alternative to backtracking PCRE-style regular expression engines"
  homepage "https://github.com/google/re2"
  url "https://github.com/google/re2/archive/2018-08-01.tar.gz"
  version "20180801"
  sha256 "7c995c91c12201e61738f35cf4d1362758894d674a1e71dd116cafb4d860b752"
  head "https://github.com/google/re2.git"

  bottle do
    cellar :any
    sha256 "dae876a42543edc7094e551baa5ae1c17189f42eac552c5b53e06c4b62640449" => :high_sierra
    sha256 "182276362e1a3eb6bd86ca20bd3d773d94cb3ffdbcdce714a1a6c07b0efb98ba" => :sierra
    sha256 "17b8953c7264c0ba05e5791dac7d92559f02ac0784a2a19bf09a3ad945cd1466" => :el_capitan
  end

  needs :cxx11

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

    ENV.cxx11

    system "make", "install", "prefix=#{prefix}"
    MachO::Tools.change_dylib_id("#{lib}/libre2.0.0.0.dylib", "#{lib}/libre2.0.dylib") if OS.mac?
    ext = OS.mac? ? "dylib" : "so"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.0.#{ext}"
    lib.install_symlink "libre2.0.0.0.#{ext}" => "libre2.#{ext}"
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
