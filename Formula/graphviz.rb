class Graphviz < Formula
  desc "Graph visualization software from AT&T and Bell Labs"
  homepage "https://www.graphviz.org/"
  url "https://gitlab.com/graphviz/graphviz.git",
      tag:      "2.47.3",
      revision: "887cd2207e6858ff2c0fe6e461dd309a435c8d5a"
  license "EPL-1.0"
  version_scheme 1
  head "https://gitlab.com/graphviz/graphviz.git"

  bottle do
    sha256 arm64_big_sur: "11e293a72d98ed531b5d8ee2b9e644acd0d4755750f7cdb2474c55c8d4b7692d"
    sha256 big_sur:       "beeecb70dee18e74a42f5d511381a1b17b946a95f821ea18b489071d07f279b4"
    sha256 catalina:      "432e8fc6232e6bd5c8d9d31c80a2cb9b1aab453ef13ea7b109043c117db2271c"
    sha256 mojave:        "5327470d2ef23770fc7227c82f527ed3f5cd41c6d418cc2ffd167b8f05423204"
    sha256 x86_64_linux:  "ebd6303944ddf9fee0b0424efb22ceea38bac41a60bc07445cb1b50eb77e05a2" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "gts"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libtool"
  depends_on "pango"

  uses_from_macos "flex" => :build
  uses_from_macos "groff" => :build

  on_linux do
    depends_on "byacc" => :build
    depends_on "ghostscript" => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-php
      --disable-swig
      --disable-tcl
      --with-quartz
      --without-freetype2
      --without-gdk
      --without-gdk-pixbuf
      --without-gtk
      --without-poppler
      --without-qt
      --without-x
      --with-gts
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"

    (bin/"gvmap.sh").unlink
  end

  test do
    (testpath/"sample.dot").write <<~EOS
      digraph G {
        a -> b
      }
    EOS

    system "#{bin}/dot", "-Tpng", "-o", "sample.png", "sample.dot"
  end
end
