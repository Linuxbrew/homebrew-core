class Camlp5 < Formula
  desc "Preprocessor and pretty-printer for OCaml"
  homepage "http://camlp5.gforge.inria.fr/"
  url "https://github.com/camlp5/camlp5/archive/rel700.tar.gz"
  version "7.00"
  sha256 "0b252388e58f879c78c075b17fc8bf3714bc070d5914425bb3adfeefa9097cfd"
  revision 1
  head "https://gforge.inria.fr/anonscm/git/camlp5/camlp5.git"

  bottle do
    sha256 "071a8cd16d168c49d505ed75a82778a6ecc3c13c2074ff4b9296a11c83ef8842" => :x86_64_linux # glibc 2.19
  end

  deprecated_option "strict" => "with-strict"
  option "with-strict", "Compile in strict mode (not recommended)"

  depends_on "ocaml"

  def install
    args = ["--prefix", prefix, "--mandir", man]
    args << "--transitional" if build.without? "strict"

    system "./configure", *args
    system "make", "world.opt"
    system "make", "install"
  end

  test do
    (testpath/"hi.ml").write "print_endline \"Hi!\";;"
    assert_equal "let _ = print_endline \"Hi!\"", shell_output("#{bin}/camlp5 #{lib}/ocaml/camlp5/pa_o.cmo #{lib}/ocaml/camlp5/pr_o.cmo hi.ml")
  end
end
