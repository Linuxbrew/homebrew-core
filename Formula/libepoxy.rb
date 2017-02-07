# libepoxy: Build a bottle for Linuxbrew
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.0.tar.xz"
  sha256 "25a906b14a921bc2b488cfeaa21a00486fe92630e4a9dd346e4ecabeae52ab41"

  bottle do
    cellar :any
    sha256 "a3cab4d43a9fa2fd109c8e47d90985770fbcc09cbebe1913cd4bf3fdc89c6fa8" => :sierra
    sha256 "2435fa039229e575b6491299548b0cc4507cfac13e62c0b5213f862902514fb2" => :el_capitan
    sha256 "f95aff4f5d3aed6991335ea6f67e3377a8a99200a554ca2cb0026c5e20630523" => :yosemite
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "linuxbrew/xorg/mesa" if OS.linux?

  def install
    ENV.universal_binary if build.universal?

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
