# libedit: Build a bottle for Linux
class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20191231-3.1.tar.gz"
  version "20191231-3.1"
  sha256 "dbb82cb7e116a5f8025d35ef5b4f7d4a3cdd0a3909a146a39112095a2d229071"

  bottle do
    cellar :any
    sha256 "faa58f2e587c5b982af44765f7a034a27837fc1e94816e094ace3f408ab4a7bf" => :catalina
    sha256 "a707377be9d5fef881cdbb77ad3b562c9d5f54befb97a10d0b7158e4db87ef86" => :mojave
    sha256 "06e087927f024a9030947216be3aaa46f97fc9dcc1b70959f60240b86bd8f574" => :high_sierra
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

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
    (testpath/"test.c").write <<~EOS
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
