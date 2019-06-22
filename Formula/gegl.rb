class Gegl < Formula
  desc "Graph based image processing framework"
  homepage "https://www.gegl.org/"
  url "https://download.gimp.org/pub/gegl/0.4/gegl-0.4.16.tar.bz2"
  sha256 "0112df690301d9eb993cc48965fc71b7751c9021a4f4ee08fcae366c326b5e5a"
  revision 1

  bottle do
    sha256 "9da6b1d38bae4761a7d855d8e60da2daa47bc939d36132dd4b9c4f5b8752f213" => :mojave
    sha256 "81646c944a251a1cd3ce58eb136782ce9dc2e9cc248b5dee867508c5323f00be" => :high_sierra
    sha256 "6e5872f57d0b9507587ba1fec345cb689954340907acba7b933b45cf8ab1f680" => :sierra
    sha256 "f716cdcbf2078835cdc4faf3e4976745fef740d736992d1a63026a5e4729ef33" => :x86_64_linux
  end

  head do
    # Use the Github mirror because official git unreliable.
    url "https://github.com/GNOME/gegl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "babl"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "json-glib"
  depends_on "libpng"

  conflicts_with "coreutils", :because => "both install `gcut` binaries"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-docs",
                          "--without-cairo",
                          "--without-jasper",
                          "--without-umfpack"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gegl.h>
      gint main(gint argc, gchar **argv) {
        gegl_init(&argc, &argv);
        GeglNode *gegl = gegl_node_new ();
        gegl_exit();
        return 0;
      }
    EOS
    flags = "-I#{include}/gegl-0.4", "-L#{lib}", "-lgegl-0.4"
    system ENV.cc, *(flags if OS.mac?),
           "-I#{Formula["babl"].opt_include}/babl-0.1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-L#{Formula["glib"].opt_lib}", "-lgobject-2.0", "-lglib-2.0",
           testpath/"test.c",
           *(flags unless OS.mac?),
           "-o", testpath/"test"
    system "./test"
  end
end
