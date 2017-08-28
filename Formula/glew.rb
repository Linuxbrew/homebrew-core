class Glew < Formula
  desc "OpenGL Extension Wrangler Library"
  homepage "https://glew.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/glew/glew/2.1.0/glew-2.1.0.tgz"
  sha256 "04de91e7e6763039bc11940095cd9c7f880baba82196a7765f727ac05a993c95"
  head "https://github.com/nigels-com/glew.git"

  bottle do
    cellar :any
    sha256 "17d6b3bbb956bd1672a26490eb58a82eaa0e3e1adb926f3e87ba060bdf999cf3" => :sierra
    sha256 "7d4cc74d42072da62ef61737bf28b638f52b4f56b2b8234f4709427eb44a11fe" => :el_capitan
    sha256 "a2f2237afc466ec31735d03c983e962240555e7ad32f2bc7b5cbceb996f48ade" => :yosemite
    sha256 "b18af3c3b992bcc2f56f43e1f3454b73665a87b07982e0409ccaae8430c35039" => :x86_64_linux # glibc 2.19
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "linuxbrew/xorg/mesa" # required to build
    depends_on "freeglut" # required for test
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
    (testpath/"test.c").write <<-EOS.undent
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
