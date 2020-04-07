class Bison < Formula
  desc "Parser generator"
  homepage "https://www.gnu.org/software/bison/"
  url "https://ftp.gnu.org/gnu/bison/bison-3.5.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/bison/bison-3.5.4.tar.xz"
  sha256 "4c17e99881978fa32c05933c5262457fa5b2b611668454f8dc2a695cd6b3720c"

  bottle do
    sha256 "1da0de53472ab236628591350fbe698813346b1d4872b8eeb8d64cfb9bdcfb30" => :catalina
    sha256 "c5e99518c9de078e871dfb65c69aede23b2461d032bf49b532fd5d070f173b66" => :mojave
    sha256 "aa6db07664e762971795b1bf255d7991d642ba3b3e5c9db9f135503810176bad" => :high_sierra
    sha256 "ec3482fa40bca3d0dec0e128bdae1ee1d191930b35d0779cf00c98db927db1d8" => :x86_64_linux
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
