class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.7.2.tar.xz"
  sha256 "28a4dc2735863bec2dba238de07fcdff28c5dd2300ae9dfdb47282206cd9b9d8"

  bottle do
    sha256 "0100185bea1d4c6a8e49ae49c5ef55f62b8632a93ecaf37c947357406ddee22b" => :sierra
    sha256 "aa6f65c02240f22518bfc908063cc1f49962d1de06ef7c49cf1f9bcf03f5f814" => :el_capitan
    sha256 "7e003f5129969f4f3af726469343eebf26e64683521f1c0cf9cde830304a69d0" => :yosemite
    sha256 "fce8e54186b3707454a156c1c5fe652c5e5ac4526264eaa7c823d10d89480b62" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  if OS.mac?
    depends_on :x11
    depends_on "bison" => :build
  end
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "linuxbrew/xorg/xkeyboardconfig"
    depends_on "linuxbrew/xorg/libxcb"
  end

  def install
    system "./autogen.sh" if build.head?
    if OS.mac?
      inreplace "configure" do |s|
        s.gsub! "-version-script $output_objdir/$libname.ver", ""
        s.gsub! "$wl-version-script", ""
      end
      inreplace %w[Makefile.in Makefile.am] do |s|
        s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon.map", ""
        s.gsub! "-Wl,--version-script=${srcdir}/xkbcommon-x11.map", ""
      end
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
    #include <stdlib.h>
    #include <xkbcommon/xkbcommon.h>
    int main() {
      return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
        ? EXIT_FAILURE
        : EXIT_SUCCESS;
    }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
