class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.15.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.15.tar.gz"
  sha256 "f9fde3207f67ed8a5a5ddd8ad5e7acf7b27c2cf0f20dfbdde876dcd6e3d2dc0e"

  bottle do
    cellar :any
    sha256 "04899aebecf79de7b1a1fd56ea2c57443bb8a3b4741e006c38c233554ccb0672" => :high_sierra
    sha256 "aeb282fe2d4fbee1f056b7da013db3355ee8644979bcb55cbdd97f8bc21fe240" => :sierra
    sha256 "826e5048722eb9ba535b8b3da24b0cb93fe7a3a47a19b1f034c40ffbb85304b8" => :el_capitan
    sha256 "ad4f929f5ae5b6aa1baa07c01ff381925292bdb6e53b5840a5c76205f385e0ec" => :x86_64_linux
  end

  if OS.mac?
    option "with-libgdbm-compat", "Build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  else
    option "without-libgdbm-compat", "Do not build libgdbm_compat, a compatibility layer which provides UNIX-like dbm and ndbm interfaces."
  end

  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --without-readline
      --prefix=#{prefix}
    ]

    args << "--enable-libgdbm-compat" if build.with? "libgdbm-compat"

    # GDBM uses some non-standard GNU extensions,
    # enabled with -D_GNU_SOURCE.  See:
    #   https://patchwork.ozlabs.org/patch/771300/
    #   https://stackoverflow.com/questions/5582211
    #   https://www.gnu.org/software/automake/manual/html_node/Flag-Variables-Ordering.html
    #
    # Fix error: unknown type name 'blksize_t'
    args << "CPPFLAGS=-D_GNU_SOURCE" unless OS.mac? || build.bottle?

    system "./configure", *args
    system "make", "install"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match /2/, pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
