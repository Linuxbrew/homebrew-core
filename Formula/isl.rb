class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  if OS.mac?
    url "http://isl.gforge.inria.fr/isl-0.19.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/isl/isl_0.19.orig.tar.xz"
    sha256 "6d6c1aa00e2a6dfc509fa46d9a9dbe93af0c451e196a670577a148feecf6b8a5"
  else
    url "http://isl.gforge.inria.fr/isl-0.18.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
    sha256 "0f35051cc030b87c673ac1f187de40e386a1482a0cfdf2c552dd6031b307ddc4"
  end

  bottle do
    cellar :any
    sha256 "e286024c142af0e968d8562e83745a05dd059dbe226c41fe6053c8fd481815fe" => :high_sierra
    sha256 "23c7305a7f227e1749a15584eb203ec9f1f49f1f4312753a9ee360f89b71d304" => :sierra
    sha256 "c00c85da652a572356e54cad1a6ff986f136f6088c142dfcdbfc166bd7144d1e" => :el_capitan
    sha256 "964e01eb84ffc9082464b5232d8965f8b6d92dc691d8525d0b6daca88154c4ca" => :x86_64_linux
  end

  head do
    url "http://repo.or.cz/r/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make", "check"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lisl", "-o", "test"
    system "./test"
  end
end
