class Libxslt < Formula
  desc "C XSLT library for GNOME"
  homepage "http://xmlsoft.org/XSLT/"
  url "http://xmlsoft.org/sources/libxslt-1.1.34.tar.gz"
  sha256 "98b1bd46d6792925ad2dfe9a87452ea2adebf69dcb9919ffd55bf926a7f93f7f"
  license "X11"
  revision OS.mac? ? 3 : 4
  head "https://gitlab.gnome.org/GNOME/libxslt.git"

  livecheck do
    url "http://xmlsoft.org/sources/"
    regex(/href=.*?libxslt[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "98a652b7c5300dcd0c74b096cbc6e86004d6a794f0de5f5188839c787a0bcc60" # linuxbrew-core
  end

  keg_only :provided_by_macos

  # Move `autoconf`, `automake` and `libtool` to head block in the next release
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libgcrypt"
  depends_on "libxml2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Fix configure script for libxml2
  # Remove in the next release
  patch do
    url "https://gitlab.gnome.org/GNOME/libxslt/-/commit/90c34c8bb90e095a8a8fe8b2ce368bd9ff1837cc.diff"
    sha256 "0ddf5ec74855e7e2fddcf8c963fe1d83f71462823a0131fc3a76a369d00f1851"
  end

  def install
    # Make it only for head builds (if build.head?) in the next release
    system "autoreconf", "-fiv"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--with-crypto",
                          "--with-libxml-prefix=#{Formula["libxml2"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      To allow the nokogiri gem to link against this libxslt run:
        gem install nokogiri -- --with-xslt-dir=#{opt_prefix}
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xslt-config --version")
    (testpath/"test.c").write <<~EOS
      #include <libexslt/exslt.h>
      int main(int argc, char *argv[]) {
        exsltCryptoRegister();
        return 0;
      }
    EOS
    flags = shell_output("#{bin}/xslt-config --cflags --libs").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags, "-lexslt"
    system "./test"
  end
end
