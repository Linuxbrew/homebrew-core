class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "http://thrysoee.dk/editline/"
  url "http://thrysoee.dk/editline/libedit-20170329-3.1.tar.gz"
  version "20170329-3.1"
  sha256 "91f2d90fbd2a048ff6dad7131d9a39e690fd8a8fd982a353f1333dd4017dd4be"

  bottle do
    cellar :any
    sha256 "1bac371537a7a38d1193bcbe80170b5a2d592f568c5d7f6f8e01fd2fada68a3f" => :sierra
    sha256 "3015b4190af4a5ddf26739884dde6ebb289cc16187958213d904551a51777013" => :el_capitan
    sha256 "45a9c2abf6fb9cd0c8cdcbad8a708e00879aef224b573069cc21cdb6e42e109b" => :yosemite
    sha256 "4ca6431ac5f8e5c1d854c69eae28889b220482abb134831cf6a9a3bce80a1877" => :x86_64_linux # glibc 2.19
  end

  keg_only :provided_by_osx

  depends_on "ncurses" unless OS.mac?

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    unless OS.mac?
      # Conflicts with ncurses.
      mv man3/"history.3", man3/"history_libedit.3"
      # Symlink libedit.so.0 to libedit.so.2 for binary compatibility with Debian/Ubuntu.
      ln_s lib/"libedit.so.0", lib/"libedit.so.2"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end
