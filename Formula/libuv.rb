class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.37.0.tar.gz"
  sha256 "7afa3c8a326b3eed02a9addb584ae7e995ae4d30516cad5e1e4af911931162a6"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "d4e33db48819f466b6b1391242f95f1e61ccd0e27418693610a5eeec20633350" => :catalina
    sha256 "57bf25fd1ab863968f9a82edd549b4374af5d0f135fd050c31d26782f5ca7924" => :mojave
    sha256 "c70a5ebdc2056c76571a82c25e7767ff36ff8f77c4349f641b4f4c841a7d337f" => :high_sierra
    sha256 "086dbbc5e446f549a39f933cc3c3e885fe28a64f52c57ca08f63ed21826b75d4" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build

  def install
    # This isn't yet handled by the make install process sadly.
    cd "docs" do
      system "make", "man"
      system "make", "singlehtml"
      man1.install "build/man/libuv.1"
      doc.install Dir["build/singlehtml/*"]
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uv.h>
      #include <stdlib.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-luv", "-o", "test"
    system "./test"
  end
end
