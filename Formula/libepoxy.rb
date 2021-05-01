class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://download.gnome.org/sources/libepoxy/1.5/libepoxy-1.5.6.tar.xz"
  sha256 "5b38c330f22430e516bd925aa0248d247486c17092bb3c8570f8211955e6258c"
  license "MIT"

  # We use a common regex because libepoxy doesn't use GNOME's "even-numbered
  # minor is stable" version scheme.
  livecheck do
    url :stable
    regex(/libepoxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7db980cb3bd2ee6f121cca0d9039965460ed99516fd83bd66beb00a0281f34f1"
    sha256 cellar: :any,                 big_sur:       "bbf7d15c4937101479c15e3fcaf5ca9311d4862e2aa26aa69653841f1432ad73"
    sha256 cellar: :any,                 catalina:      "634e7833ff644eb9deda3a21a0194b178295d4b120b7f1f7eb6080ddd6325548"
    sha256 cellar: :any,                 mojave:        "9b6337f51f9fe1d49b7260f07caee990b1cd7e30c032a41c873eb25d8d1b7751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9552aae67e1da190feffcbd794d44fd53a733470c8cbb0c81885999d1a2ba29f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  depends_on "freeglut" unless OS.mac?

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
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
      #include <OpenGL/OpenGL.h>
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
