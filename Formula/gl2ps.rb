class Gl2ps < Formula
  desc "OpenGL to PostScript printing library"
  homepage "https://www.geuz.org/gl2ps/"
  url "https://geuz.org/gl2ps/src/gl2ps-1.4.1.tgz"
  sha256 "7362034b3d00ceef5601ff2d3dadb232c6678924e2594f32d73dfc9b202d5d3b"

  bottle do
    cellar :any
    sha256 "9892a2bca2e64d36ba64d136aabb4113096c85d986b39c37291c1ad4a54b1cf4" => :catalina
    sha256 "4975b6204df6681770a50e56ad8c689b1a3f8ba1ab1156054210afe60d1cee68" => :mojave
    sha256 "e4ce5d49e23926babfc2a0de59d2cefc06ead02408848430be975c51e49fa210" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  depends_on "freeglut" unless OS.mac?

  def install
    # Prevent linking against X11's libglut.dylib when it's present
    # Reported to upstream's mailing list gl2ps@geuz.org (1st April 2016)
    # https://www.geuz.org/pipermail/gl2ps/2016/000433.html
    # Reported to cmake's bug tracker, as well (1st April 2016)
    # https://public.kitware.com/Bug/view.php?id=16045
    args = std_cmake_args
    args << "-DGLUT_glut_LIBRARY=/System/Library/Frameworks/GLUT.framework" if OS.mac?
    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <#{OS.mac? ? "GLUT" : "GL"}/glut.h>
      #include <gl2ps.h>

      int main(int argc, char *argv[])
      {
        glutInit(&argc, argv);
        glutInitDisplayMode(GLUT_DEPTH);
        glutInitWindowSize(400, 400);
        glutInitWindowPosition(100, 100);
        glutCreateWindow(argv[0]);
        GLint viewport[4];
        glGetIntegerv(GL_VIEWPORT, viewport);
        FILE *fp = fopen("test.eps", "wb");
        GLint buffsize = 0, state = GL2PS_OVERFLOW;
        while( state == GL2PS_OVERFLOW ){
          buffsize += 1024*1024;
          gl2psBeginPage ( "Test", "Homebrew", viewport,
                           GL2PS_EPS, GL2PS_BSP_SORT, GL2PS_SILENT |
                           GL2PS_SIMPLE_LINE_OFFSET | GL2PS_NO_BLENDING |
                           GL2PS_OCCLUSION_CULL | GL2PS_BEST_ROOT,
                           GL_RGBA, 0, NULL, 0, 0, 0, buffsize,
                           fp, "test.eps" );
          gl2psText("Homebrew Test", "Courier", 12);
          state = gl2psEndPage();
        }
        fclose(fp);
        return 0;
      }
    EOS
    if OS.mac?
      system ENV.cc, "-L#{lib}", "-lgl2ps", "-framework", "OpenGL", "-framework",
                     "GLUT", "-framework", "Cocoa", "test.c", "-o", "test"
    else
      system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lgl2ps", "-lglut", "-lGL"
      # Fails without an X11 display: freeglut (./test): failed to open display ''
      return if ENV["CI"]
    end
    system "./test"
    assert_predicate testpath/"test.eps", :exist?
    assert_predicate File.size("test.eps"), :positive?
  end
end
