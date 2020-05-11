class Libplctag < Formula
  desc "Portable and simple API for accessing AB PLC data over Ethernet"
  homepage "https://github.com/kyle-github/libplctag"
  url "https://github.com/kyle-github/libplctag/archive/v2.1.5.tar.gz"
  sha256 "8f3e36e79d15798e339324fafecf5540a1cfdfedb582f1dcc9ae09838a159b34"

  bottle do
    cellar :any
    sha256 "ada6532b7a4d7795e4076287012f5d7943d6f47a1841ec483c69ccfaf1bb8176" => :catalina
    sha256 "923714a1e235142d584a71ec9f854d1b7bf73b7e1486257207e11a0f68144f36" => :mojave
    sha256 "fbfcc0140439b27881dec7e5d2dd10a865b7c72ed0e7ef267e27e40dd38735a7" => :high_sierra
    sha256 "0cd014a7c9ac2d527717fccf806059d1310db57d217f1edb7eeade3ed9dbe7c0" => :x86_64_linux
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <libplctag.h>

      int main(int argc, char **argv) {
        int32_t tag = plc_tag_create("protocol=ab_eip&gateway=192.168.1.42&path=1,0&cpu=LGX&elem_size=4&elem_count=10&name=myDINTArray", 1);
        if (!tag) abort();
        plc_tag_destroy(tag);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
                   *("-pthread" unless OS.mac?),
                   *("-I#{include}" unless OS.mac?),
                   *("-Wl,-rpath=#{lib}" unless OS.mac?),
                   "-L#{lib}", "-lplctag", "-o", "test"
    system "./test"
  end
end
