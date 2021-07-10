class Libuv < Formula
  desc "Multi-platform support library with a focus on asynchronous I/O"
  homepage "https://libuv.org"
  url "https://github.com/libuv/libuv/archive/v1.41.1.tar.gz"
  sha256 "62c29d1d76b0478dc8aaed0ed1f874324f6cd2d6ff4cb59a44026c09e818cd53"
  license "MIT"
  head "https://github.com/libuv/libuv.git", branch: "v1.x"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "bcaac0de0bc17b40971a1c62b7c56cde8651d3e89cd6ea4bb7e422d91ccb83d9"
    sha256 cellar: :any,                 big_sur:       "cf1c04d27f1e6175cbdb2267d868a6a7fc2a58eaabba7880c75d9a9a9c69c913"
    sha256 cellar: :any,                 catalina:      "3fe0cd053ff47541ad346f545f8279c4fc475c829f45bc6d7169602a9a84425e"
    sha256 cellar: :any,                 mojave:        "41eddc073c38f637ccf7af8bf39b771fd77f162c32716c1d22e7fabd0d3cb6b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8c01ff3270dc18306d23c9f84286313615f5dadd9c14a49f504ffbac92c92b0" # linuxbrew-core
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
