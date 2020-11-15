class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.2.tar.gz"
  sha256 "98768e12e615fbe9f3386f5bbfeb91b5a3b45a8c4c77159cef06b1f6ff749537"
  license "Zlib"
  revision 2 unless OS.mac?
  head "https://github.com/glfw/glfw.git"

  bottle do
    cellar :any
    sha256 "2d5c251cffe0dca47f83199b0b0fc500b3464888fd244dd6969a055bf2530d8d" => :big_sur
    sha256 "deaf1b20e9fc336d5f0c9a927bc07f2c509fc63538c39e4ab3a024ca7c6170d8" => :catalina
    sha256 "0c0de277c23273346d703004279d92d17a8962f4d62bf01f76021beea3c3f20a" => :mojave
    sha256 "c6a198383ef979823c1e0071e65771ed9059626071390f2dc5b84b218dc565c3" => :high_sierra
    sha256 "cac7fec8f28963def819c8b5211cef64d57d8198280a3b4e9ff5530305913ea5" => :x86_64_linux
  end

  depends_on "cmake" => :build

  unless OS.mac?
    depends_on "freeglut"
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    # glfw doesn't work in headless mode
    return if !OS.mac? && ENV["CI"]

    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"
    system "./test"
  end
end
