# libepoxy: Build a bottle for Linuxbrew
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.4/libepoxy-1.4.2.tar.xz"
  sha256 "bea6fdec3d10939954495da898d872ee836b75c35699074cbf02a64fcb80d5b3"

  bottle do
    cellar :any
    sha256 "ebaebfb27513e366d1917e48a2fd1f2c68394a7213f35f4b4d88d96db8d6757f" => :sierra
    sha256 "54e86d039473c9971023253694b36d8a38824f4df97a8095de90bb4bf0557d8f" => :el_capitan
    sha256 "fcf8b7560ec836403bcae4d69a16c27793a7042b09673e1c2914cf010d6381f1" => :yosemite
    sha256 "f618cda0cf5a300932a70d9103632e54aa2a814962f3b4bbd23dfc1fc5d391cd" => :x86_64_linux
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
