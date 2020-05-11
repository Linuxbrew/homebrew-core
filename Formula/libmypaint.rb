class Libmypaint < Formula
  desc "MyPaint brush engine library"
  homepage "https://github.com/mypaint/libmypaint/wiki"
  url "https://github.com/mypaint/libmypaint/releases/download/v1.6.0/libmypaint-1.6.0.tar.xz"
  sha256 "a5ec3624ba469b7b35fd66b6fbee7f07285b7a7813d02291ac9b10e46618140e"

  bottle do
    cellar :any
    sha256 "95a944824d2866d0fc1fd32ad32422f290c388ec1920cb5a71beebc631d317ae" => :catalina
    sha256 "d4874ceaaed108cb5e3e55269e2de8b7c63e99a4ea8f037e3cb0e7a2bcee6520" => :mojave
    sha256 "b7ffe5692ec273a37c37cda7d0f6082e9301b14035b618846e7894c2b4393954" => :high_sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"

  def install
    system "./configure", "--disable-introspection",
                          "--without-glib",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mypaint-brush.h>
      int main() {
        MyPaintBrush *brush = mypaint_brush_new();
        mypaint_brush_unref(brush);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/libmypaint", "-L#{lib}", "-lmypaint", "-o", "test"
    system "./test"
  end
end
