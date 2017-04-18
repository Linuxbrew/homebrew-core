# libepoxy: Build a bottle for Linuxbrew
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.1.tar.xz"
  sha256 "88c6abf5522fc29bab7d6c555fd51a855cbd9253c4315f8ea44e832baef21aa6"

  bottle do
    cellar :any
    sha256 "e475eea8fa81f14b2984da71874ec3c00c8e9edcec84e9ae15eb0df5926afec7" => :sierra
    sha256 "1f064ae908ed05131d247a67361bfc7532378b29d973e464a832e89b81d7a415" => :el_capitan
    sha256 "427431ddadd2bc8da2e970be23ea8c04e46a1e117c6cde38b22a69ea428c9bb7" => :yosemite
    sha256 "c1820427bea501adb808ec4500000a77032f32f5903289f56768a47e53317e5f" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "linuxbrew/xorg/mesa" if OS.linux?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent

      #include <epoxy/gl.h>
      #ifdef OS_MAC
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      #endif
      int main()
      {
          #ifdef OS_MAC
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);
          #endif

          glClear(GL_COLOR_BUFFER_BIT);
          #ifdef OS_MAC
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          #endif
          return 0;
      }
    EOS
    args = %w[-lepoxy -o test]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
