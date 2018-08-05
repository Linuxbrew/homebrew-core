# libxkbcommon: Build a bottle for Linuxbrew
class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.1.tar.xz"
  sha256 "8d1df6bdf216950da611e66cff1af576710aad79772de3be6e131019f761f897"

  bottle do
    sha256 "312c64c48750fc47521bcb885c7df0e1861faefe860f56a3da07ab21ceab82ee" => :high_sierra
    sha256 "c62af888dc0c7440c5c7c3554fa0525a74164a1fc64d6a96c3287bb62e923073" => :sierra
    sha256 "118510c232bf71eb5dd5c2601a07a47d9c478053359e5bad0eb05705d7645e05" => :el_capitan
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11 if OS.mac?
  depends_on "bison" => :build
  depends_on "pkg-config" => :build

  unless OS.mac?
    depends_on "linuxbrew/xorg/xkeyboardconfig"
    depends_on "linuxbrew/xorg/xorg"
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
    (testpath/"test.c").write <<~EOS
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
