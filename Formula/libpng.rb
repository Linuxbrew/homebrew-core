class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.37/libpng-1.6.37.tar.xz"
  sha256 "505e70834d35383537b6491e7ae8641f1a4bed1876dbfe361201fc80868d88ca"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "766a7136ee626b411fb63da0c7e5bc1e848afb6e224622f25ea305b2d1a4a0f1"
    sha256 cellar: :any, big_sur:       "a8f1c35f9f004c4f7878c30027e35a9fb9551782df963f88deebd3dc29d94d51"
    sha256 cellar: :any, catalina:      "c8e74da602c21f978cd7ee3d489979b4fc6681e71f678a1d99012943ee3a909f"
    sha256 cellar: :any, mojave:        "53bbd14cc27c86c16605e256e7646a1b5656c253abca084958c5d80a2961cb01"
    sha256 cellar: :any, high_sierra:   "bbdd94bdd5954bc50c096391486e67265dce5631efb913dcffe4469806a242b6"
    sha256 cellar: :any, sierra:        "e66797079a9a8134f91bd36b58054c6c32f6a9cd161c1bd19f0192319edb80aa"
    sha256 cellar: :any, x86_64_linux:  "c5d219b27780c730af50693110ed2c79e50200d3595c7e395998fe3950354ec9"
  end

  head do
    url "https://github.com/glennrp/libpng.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
