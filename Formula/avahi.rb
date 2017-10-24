class Avahi < Formula
  desc "Service Discovery for Linux using mDNS/DNS-SD"
  homepage "http://avahi.org"
  url "https://github.com/lathiat/avahi/archive/v0.6.32.tar.gz"
  sha256 "7eb693d878246f0cd05034173fb3ed53447a84dd3b7f01745313cad11071226e"
  # tag "linuxbrew"

  depends_on "libdaemon"
  depends_on "pygtk"
  depends_on "python-dbus"
  depends_on "intltool"
  depends_on "xmltoman" => :build
  depends_on "gtk-sharp"
  depends_on "qt"
  depends_on "gtk+3"

  def install
    system "./bootstrap.sh", "--disable-debug",
                             "--disable-dependency-tracking",
                             "--disable-silent-rules",
                             "--prefix=#{prefix}",
                             "--sysconfdir=#{prefix}/etc",
                             "--localstatedir=#{prefix}/var"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <string.h>

      #include <ggz.h>

      int main(void)
      {
        int errs = 0;
        char *teststr, *instr, *outstr;

        teststr = "&quot; >< &&amp";
        instr = teststr;
        outstr = ggz_xml_escape(instr);
        instr = ggz_xml_unescape(outstr);
        if(strcmp(instr, teststr)) {
          errs++;
        }
        ggz_free(instr);
        ggz_free(outstr);
        ggz_memory_check();

        return errs;
      }
    EOS
    system ENV.cc, "test.c", ENV.cppflags, "-L/usr/lib", "-L#{lib}", "-lggz", "-o", "test"
    system "./test"
  end
end
