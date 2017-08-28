class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.4.tar.gz"
  sha256 "695370c15d839dafbbb4c0222a22ee0af4859475b0b1b66e52ccb854cd91060c"

  bottle do
    cellar :any
    sha256 "513b4ceb7dd3c50cebe436fe57eae549e3af5e97f074231b337dac4075d8f40d" => :sierra
    sha256 "948b614c46b7ee5943f93412e46efdcb15497349d61398b1720ee4351b8df4ed" => :el_capitan
    sha256 "cecbe216cbb73cb8f6b0cadf4198eb2f3ad296e0e5ced9acb51c24cd0efc8f71" => :yosemite
    sha256 "c983789206c1e35ca81b5b5f63c655994356d4d0a09943bc0eead981c595e91e" => :x86_64_linux # glibc 2.19
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
