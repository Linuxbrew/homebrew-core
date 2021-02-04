class Libimagequant < Formula
  desc "Palette quantization library extracted from pnquant2"
  homepage "https://pngquant.org/lib/"
  url "https://github.com/ImageOptim/libimagequant/archive/2.14.0.tar.gz"
  sha256 "ad3d3cbc7b2c065d96391ee532b9ee4b7d406fed6be84446a5283ce1bad519eb"
  license :cannot_represent

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ec56d3c2b5f3df3dcd24649f0ada66862ae7848c240c5e47323a5990a528636"
    sha256 cellar: :any_skip_relocation, big_sur:       "863269f70a434edaa3723358d05f1bbbbde6421c3ab547278b0e9352f16e7bf8"
    sha256 cellar: :any_skip_relocation, catalina:      "4ba0f5ead6703bb5aacae5c418c2d15babbce21721df21ab176e1709a2108a9a"
    sha256 cellar: :any_skip_relocation, mojave:        "ad7c57b0ee19056cce578be0cd08aada81be753dafd387365846c6a5e4a93cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "114d2ac5bb3c106854936b18c12f9f7fd52375472b1d03015582af913dac8673"
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
