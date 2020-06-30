class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  revision OS.mac? ? 1 : 3
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "590c10bf98e6263d8e573720e5521584d836f28c52f30f97840614e97c16ccfd" => :catalina
    sha256 "66638564b5b9d2d915b97841ef1cc117f701c7ec34707734fa1ce11919c28821" => :mojave
    sha256 "1d3b4e7938d3c1fc7e16f78a506163046da105b443498b7ca1a3cca78f232739" => :high_sierra
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "freeglut" => :test
    depends_on "linuxbrew/xorg/glu"
    depends_on "mesa"
  end

  def install
    cd "build" do
      system "cmake", "./cmake", *std_cmake_args
      system "make"
      system "make", "install"
    end
    doc.install Dir["doc/*"]
  end

  test do
    if ENV["DISPLAY"].nil?
      ohai "Can not test without a display."
      return true
    end
    (testpath/"test.c").write <<~EOS
      #include <GL/glew.h>
      #include <#{OS.mac? ? "GLUT" : "GL"}/glut.h>

      int main(int argc, char** argv) {
        glutInit(&argc, argv);
        glutCreateWindow("GLEW Test");
        GLenum err = glewInit();
        if (GLEW_OK != err) {
          return 1;
        }
        return 0;
      }
    EOS
    flags = %W[-L#{lib} -lGLEW]
    if OS.mac?
      flags << "-framework" << "GLUT"
    else
      flags << "-lglut"
    end
    system ENV.cc, testpath/"test.c", "-o", "test", *flags
    system "./test"
  end
end
