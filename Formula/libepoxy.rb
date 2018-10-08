# libepoxy: Build a bottle for Linuxbrew
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.3.tar.xz"
  sha256 "002958c5528321edd53440235d3c44e71b5b1e09b9177e8daf677450b6c4433d"

  bottle do
    cellar :any
    sha256 "2effda8b89a49b5dbd3860061666757e58ba982534e42507e29ea3646f896178" => :mojave
    sha256 "0f7ebb1bf7449c25196dd2f3500e520a2b0eb67ac21263ec87c9d02c7d9e7e58" => :high_sierra
    sha256 "147538004325b02238d187ec1ef55944a0e74fe83accf1506904b62d01f75ec2" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  unless OS.mac?
    depends_on "freeglut"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/xorg"
    depends_on "linuxbrew/xorg/damageproto"
    depends_on "linuxbrew/xorg/fixesproto"
    depends_on "linuxbrew/xorg/kbproto"
    depends_on "linuxbrew/xorg/xf86vidmodeproto"
    depends_on "linuxbrew/xorg/xextproto"
  end

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", *("--libdir=#{lib}" unless OS.mac?), ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS

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
    args = %w[-lepoxy]
    args += %w[-framework OpenGL -DOS_MAC] if OS.mac?
    args += %w[-o test]
    system ENV.cc, "test.c", *args
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
