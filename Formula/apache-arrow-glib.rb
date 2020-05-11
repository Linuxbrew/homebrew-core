class ApacheArrowGlib < Formula
  desc "GLib bindings for Apache Arrow"
  homepage "https://arrow.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=arrow/arrow-0.17.0/apache-arrow-0.17.0.tar.gz"
  mirror "https://archive.apache.org/dist/arrow/arrow-0.17.0/apache-arrow-0.17.0.tar.gz"
  sha256 "2c46b4c3e1f88aad510214e633a6f4ce459708f3db78cd0daf549a135cbe8e6d"
  head "https://github.com/apache/arrow.git"

  bottle do
    sha256 "8654499e86045a221e5a7d5d3030288d8a27ae06a8801dcfe8e82c7b86ec4653" => :catalina
    sha256 "cb9eee87497902c591de9edd7ffc7331541d02f21a4ea4255b0de1d0ff69de54" => :mojave
    sha256 "fa8dd856ba70113b4eaa3dd6d6a685115d377a1a82fddf839f2761b550ef31d3" => :high_sierra
    sha256 "4ee8bec6cd07ba93161577c1a9817762aac3a9147b7e83fe5821a012de42191b" => :x86_64_linux
  end

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "apache-arrow"
  depends_on "glib"

  def install
    cd "c_glib" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~SOURCE
      #include <arrow-glib/arrow-glib.h>
      int main(void) {
        GArrowNullArray *array = garrow_null_array_new(10);
        g_object_unref(array);
        return 0;
      }
    SOURCE
    apache_arrow = Formula["apache-arrow"]
    glib = Formula["glib"]
    flags = %W[
      -I#{include}
      -I#{apache_arrow.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{apache_arrow.opt_lib}
      -L#{glib.opt_lib}
      -DNDEBUG
      -larrow-glib
      -larrow
      -lglib-2.0
      -lgobject-2.0
      -lgio-2.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
