class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  # X.Y.9Z are beta releases that sometimes get accidentally uploaded to the release FTP
  url "https://ftp.gnu.org/gnu/bison/bison-3.6.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.6.1.tar.xz"
  sha256 "67ff4539783569884cbecaf781ceb665fc92e4ef3cf44c507a49d06a87421398"
  version_scheme 1

  bottle do
    sha256 "38b9aad3a92818ffeb444b098f68dc5fff1f55941f800326640754f605b7a611" => :catalina
    sha256 "c8630dddc2c28e2ca81a331cfe7af3689a86276f301f7fec82a93f52da581fe9" => :mojave
    sha256 "ab1c129cec316d67552115431726781a7f4ae95c089a1829e96bc95a6dadcff3" => :high_sierra
    sha256 "64ef951b872fdd7b7f8b61823c677352f8f07b407ac0e5cb6c4dc9cf2c373884" => :x86_64_linux
  end

  keg_only :provided_by_macos

  uses_from_macos "m4"

  def install
    # https://www.mail-archive.com/bug-guix@gnu.org/msg13512.html
    ENV.deparallelize unless OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.y").write <<~EOS
      %{ #include <iostream>
         using namespace std;
         extern void yyerror (char *s);
         extern int yylex ();
      %}
      %start prog
      %%
      prog:  //  empty
          |  prog expr '\\n' { cout << "pass"; exit(0); }
          ;
      expr: '(' ')'
          | '(' expr ')'
          |  expr expr
          ;
      %%
      char c;
      void yyerror (char *s) { cout << "fail"; exit(0); }
      int yylex () { cin.get(c); return c; }
      int main() { yyparse(); }
    EOS
    system "#{bin}/bison", "test.y"
    system ENV.cxx, "test.tab.c", "-o", "test"
    assert_equal "pass", shell_output("echo \"((()(())))()\" | ./test")
    assert_equal "fail", shell_output("echo \"())\" | ./test")
  end
end
