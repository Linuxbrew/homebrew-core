class Libnice < Formula
  desc "GLib ICE implementation"
  homepage "https://wiki.freedesktop.org/nice/"
  url "https://nice.freedesktop.org/releases/libnice-0.1.14.tar.gz"
  sha256 "be120ba95d4490436f0da077ffa8f767bf727b82decf2bf499e39becc027809c"

  bottle do
    cellar :any
    sha256 "3782f1868a247063e772f0ac5b9f59524ed6c0ad5a72e1d96af7078e5a36f526" => :sierra
    sha256 "f9247e1697faac654fa25fc461f080486731d8fbcffc7855c46ab9c716fa62fc" => :el_capitan
    sha256 "2cbf1077ed2e87caf285188031d47710bedc3bfb801f1f0a87ca0fbb081c8e30" => :yosemite
    sha256 "1ad64bc5204c131c3d685e2c650e535c3f5e7605c6ef859e12c51b49e27983c5" => :x86_64_linux # glibc 2.19
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gstreamer"
  depends_on "intltool" => :build unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Based on https://github.com/libnice/libnice/blob/master/examples/simple-example.c
    (testpath/"test.c").write <<-EOS.undent
      #include <agent.h>
      int main(int argc, char *argv[]) {
        NiceAgent *agent;
        GMainLoop *gloop;
        gloop = g_main_loop_new(NULL, FALSE);
        // Create the nice agent
        agent = nice_agent_new(g_main_loop_get_context (gloop),
          NICE_COMPATIBILITY_RFC5245);
        if (agent == NULL)
          g_error("Failed to create agent");

        g_main_loop_unref(gloop);
        g_object_unref(agent);
        return 0;
      }
    EOS

    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/nice
      -D_REENTRANT
      test.c
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lnice
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cc, *flags, "-o", "test"
    system "./test"
  end
end
