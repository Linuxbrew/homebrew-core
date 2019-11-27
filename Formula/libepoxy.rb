# libepoxy: Build a bottle for Linux
class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.4.tar.xz"
  sha256 "0bd2cc681dfeffdef739cb29913f8c3caa47a88a451fd2bc6e606c02997289d2"

  bottle do
    cellar :any
    sha256 "96e139bc93053e6bb0a03201169e16c6112ef0ab27cdc648d35a26f2d786855c" => :catalina
    sha256 "c2f968269360ad31b30d6635d234cdc82e926fd109f3ac3aa4eb2a71f27f3ceb" => :mojave
    sha256 "3ed4dbf8d3715738c5226c0466b7ace7a57b4a49dc838d3260d5d8acd82c1a07" => :high_sierra
    sha256 "9a4ac2307e210de830f50bc8914a85b34054cf7243ec3762b99fc8a08c7714f6" => :x86_64_linux
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  unless OS.mac?
    depends_on "freeglut"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/xorg"
    depends_on "linuxbrew/xorg/xorgproto"
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
