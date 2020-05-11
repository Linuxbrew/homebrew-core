class Libnsl < Formula
  desc "Public client interface for NIS(YP) and NIS+"
  homepage "https://github.com/thkukuk/libnsl"
  url "https://github.com/thkukuk/libnsl/archive/v1.2.0.tar.gz"
  sha256 "a5a28ef17c4ca23a005a729257c959620b09f8c7f99d0edbfe2eb6b06bafd3f8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4595f4ad9116022fef72721d411251d667a4ad906bb6d6459125cf36455234ac" => :x86_64_linux
  end

  keg_only "it conflicts with glibc"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
  depends_on "m4" => :build
  depends_on "pkg-config" => :build
  depends_on "libtirpc"
  depends_on :linux

  def install
    inreplace "po/Makefile.in.in" do |s|
      s.gsub! /GETTEXT_MACRO_VERSION =.*/,
        "GETTEXT_MACRO_VERSION = #{Formula["gettext"].version.to_s[/(\d\.\d+)/, 1]}"
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
      #include <rpcsvc/nis.h>

      int main(int argc, char *argv[])
      {
        if(NIS_PK_NONE != 0)
          return 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnsl", "-o", "test"
    system "./test"
  end
end
