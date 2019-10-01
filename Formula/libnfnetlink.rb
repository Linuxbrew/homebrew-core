class Libnfnetlink < Formula
  desc "Low-level library for netfilter related communication"
  homepage "https://www.netfilter.org/projects/libnfnetlink"
  url "git://git.netfilter.org/libnfnetlink",
    :tag      => "libnfnetlink-1.0.1",
    :revision => "1166116e34af868bc814aea338c246e49a7a8748"
  # tag "linuxbrew"

  bottle do
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libnfnetlink/libnfnetlink.h>

      int main() {
        int i = NFNL_BUFFSIZE;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnfnetlink", "-o", "test"
  end
end
