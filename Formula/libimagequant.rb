class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.13.1.tar.gz"
  sha256 "1f46deec3fa280335cf7f0be3ede6006bb420ba8159a03d1f6938e8d283d03ae"
  license :cannot_represent

  bottle do
    cellar :any
    sha256 "4eec259853e8c650282ab0f9fe2fe382cfb0c63adf50eefb0e53038e9579b117" => :big_sur
    sha256 "f25c23a8535d4831269b8f78d2b1e8065cf6b045835467b493056c5e810f863c" => :arm64_big_sur
    sha256 "ddaab4f5d02ee638676c716701a3e4364c76a3e6184787b2b5bc078b95497fb2" => :catalina
    sha256 "f7902838c7698902828571a5bbb170a1855ee66d96070e7b577b9a332370989b" => :mojave
    sha256 "301eecb83d913c8c44d8c91718e0d9264f0f5d83e2237f1af507573b5092f867" => :x86_64_linux
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libimagequant.h>

      int main()
      {
        liq_attr *attr = liq_attr_create();
        if (!attr) {
          return 1;
        } else {
          liq_attr_destroy(attr);
          return 0;
        }
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-limagequant", "-o", "test"
    system "./test"
  end
end
