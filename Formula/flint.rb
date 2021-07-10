class Flint < Formula
  desc "C library for number theory"
  homepage "https://flintlib.org"
  url "https://flintlib.org/flint-2.7.1.tar.gz"
  sha256 "186e2fd9ab67df8a05b122fb018269b382e4babcdb17353c4be1fe364dca481e"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://github.com/wbhart/flint2.git", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "76a41ad303e485cad7795c7668a488945a4aa1e15b31d0cf60aa67417d818ea8"
    sha256 cellar: :any,                 big_sur:       "6b6b6fe83f4e2827f57c673598791048b364efe8c554dc7293bfc1594d5aa9e9"
    sha256 cellar: :any,                 catalina:      "a98cb754d82e32e1072548661fe76bf4ba37388a0497ca5ca7466c45679faab4"
    sha256 cellar: :any,                 mojave:        "6d223d4c47e57d7080d3e9c70aee75256153268cd75682972dcdc43b8a8eda6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d67abf5bf99b176f7e11a9845d6128e9dbbff00aa86706435dde62c0e3e4b045" # linuxbrew-core
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ntl"

  def install
    ENV.cxx11
    args = %W[
      --with-gmp=#{Formula["gmp"].prefix}
      --with-mpfr=#{Formula["mpfr"].prefix}
      --with-ntl=#{Formula["ntl"].prefix}
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include "flint.h"
      #include "fmpz.h"
      #include "ulong_extras.h"

      int main(int argc, char* argv[])
      {
          slong i, bit_bound;
          mp_limb_t prime, res;
          fmpz_t x, y, prod;

          if (argc != 2)
          {
              flint_printf("Syntax: crt <integer>\\n");
              return EXIT_FAILURE;
          }

          fmpz_init(x);
          fmpz_init(y);
          fmpz_init(prod);

          fmpz_set_str(x, argv[1], 10);
          bit_bound = fmpz_bits(x) + 2;

          fmpz_zero(y);
          fmpz_one(prod);

          prime = 0;
          for (i = 0; fmpz_bits(prod) < bit_bound; i++)
          {
              prime = n_nextprime(prime, 0);
              res = fmpz_fdiv_ui(x, prime);
              fmpz_CRT_ui(y, y, prod, res, prime, 1);

              flint_printf("residue mod %wu = %wu; reconstruction = ", prime, res);
              fmpz_print(y);
              flint_printf("\\n");

              fmpz_mul_ui(prod, prod, prime);
          }

          fmpz_clear(x);
          fmpz_clear(y);
          fmpz_clear(prod);

          return EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/flint", "-L#{lib}", "-L#{Formula["gmp"].lib}",
           "-lflint", "-lgmp", "-o", "test"
    system "./test", "2"
  end
end
