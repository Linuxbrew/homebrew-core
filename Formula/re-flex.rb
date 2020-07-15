class ReFlex < Formula
  desc "The regex-centric, fast and flexible scanner generator for C++"
  homepage "https://www.genivia.com/doc/reflex/html"
  url "https://github.com/Genivia/RE-flex/archive/v2.1.2.tar.gz"
  sha256 "d5affd1b2368b5a14377089416b7357a16e8f4ff6738ed30c06018a3715fc270"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "a7f3da3f734666c91fbf68e7f1c6ff82d832ba60dd8aae8c26f2d6cb69f1a7af" => :catalina
    sha256 "1be1c7ab5fc883d150afd08ee7d83866877c78ea4931abed024990fdbbd8aff5" => :mojave
    sha256 "a8f17566d3ae4335ea8582e8e4ee29a712e4fcdfa7519c2e5225498d77e57901" => :high_sierra
  end

  depends_on "pcre2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"echo.l").write <<~'EOS'
      %{
      #include <stdio.h>
      %}
      %option noyywrap main
      %%
      .+  ECHO;
      %%
    EOS
    system "#{bin}/reflex", "--flex", "echo.l"
    assert_predicate testpath/"lex.yy.cpp", :exist?
  end
end
