# coq: Build a bottle for Linux
class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://github.com/coq/coq/archive/V8.10.2.tar.gz"
  sha256 "693c188f045d21f83114239dbb8af8def01b42a157c7d828087d055c32ec6e86"
  head "https://github.com/coq/coq.git"

  bottle do
    sha256 "a04bc9b5d64756ca8898714e87312888424d37e7835654917f7a3116efa58f88" => :catalina
    sha256 "7e6b4edd76ced29b4aceaa71409b1d235163f4c54ff1025139baffd11eef28a9" => :mojave
    sha256 "375a482254e7a357630f1b86da7c456b961619b502407cd03e5c5f60178329ec" => :high_sierra
  end

  depends_on "ocaml-findlib" => :build
  depends_on "camlp5"
  depends_on "ocaml"
  depends_on "ocaml-num"

  unless OS.mac?
    depends_on "unzip" => :build
    depends_on "m4"
  end

  def install
    system "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<~EOS
      Require Coq.omega.Omega.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
