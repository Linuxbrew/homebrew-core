class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20210419-3.1.tar.gz"
  version "20210419-3.1"
  sha256 "571ebe44b74860823e24a08cf04086ff104fd7dfa1020abf26c52543134f5602"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "04ed7ad171dc9522e9a9b0d163e816f9de98837ffd71ac800906ecbc23ad6398"
    sha256 cellar: :any,                 big_sur:       "f648687d7d1328cd16d926425956bfb6617ba0212d7705d1a75e75c572cdac26"
    sha256 cellar: :any,                 catalina:      "5e65d63c667262319f8bca0613d42189a3cece68e753c9cbe44b17c8f3719d19"
    sha256 cellar: :any,                 mojave:        "432a7d0cfb00ded9d02e2da8861a5d69294c2c9b98e89e849b9a9d86310239f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b7ec53c208ab5b6c0a1308aafa7f31e3f44f216ef9ab8fbd01d90d8661054d"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    on_linux do
      # Conflicts with readline.
      mv man3/"history.3", man3/"history_libedit.3"
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
