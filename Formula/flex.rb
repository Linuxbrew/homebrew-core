class Flex < Formula
  desc "Fast Lexical Analyzer, generates Scanners (tokenizers)"
  homepage "https://flex.sourceforge.io"
  url "https://github.com/westes/flex/releases/download/v2.6.3/flex-2.6.3.tar.gz"
  sha256 "68b2742233e747c462f781462a2a1e299dc6207401dac8f0bbb316f48565c2aa"

  bottle do
    sha256 "ab9447f77fbef802c703ad7e8ac606e217205880b55b20b90c2f58674f848162" => :sierra
    sha256 "3f8c8003a5ae1f88cc397590c85787f1710f8798fcfd9ed8691d81f3df20e926" => :el_capitan
    sha256 "915dad088301f2bb607c3af7a7eb13946500e1a0566767e91ecbbcaf7c813725" => :yosemite
    sha256 "9caf4cf5a4392d041d007c700535a47afdd1befd106585d783f008ab5c341c35" => :x86_64_linux
  end

  keg_only :provided_by_osx, "Some formulae require a newer version of flex."

  depends_on "help2man" => :build
  depends_on "gettext"
  unless OS.mac?
    depends_on "homebrew/dupes/m4"
    depends_on "bison" => :build
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install_symlink "flex" => "lex" unless OS.mac?
  end

  test do
    (testpath/"test.flex").write <<-EOS.undent
      CHAR   [a-z][A-Z]
      %%
      {CHAR}+      printf("%s", yytext);
      [ \\t\\n]+   printf("\\n");
      %%
      int main()
      {
        yyin = stdin;
        yylex();
      }
    EOS
    system "#{bin}/flex", "test.flex"
    system ENV.cc, "lex.yy.c", "-L#{lib}", "-lfl", "-o", "test"
    assert_equal shell_output("echo \"Hello World\" | ./test"), <<-EOS.undent
      Hello
      World
    EOS
  end
end
