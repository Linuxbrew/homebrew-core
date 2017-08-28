class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.28.tar.gz"
  sha256 "cde2000e4642f3f88d73a317aec54e8b6036e29e81a00262daf15aca47d0d691"
  revision 1

  bottle do
    sha256 "dff61341d8d060b754d0baf61a204d9d353db59f22c8916c11f6e519338653ba" => :x86_64_linux # glibc 2.19
  end

  depends_on "ocaml"
  depends_on "ocamlbuild" => :build
  depends_on "ghostscript" => :optional

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
