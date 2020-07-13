class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2020/MonetDB-11.37.7.tar.xz"
  sha256 "8496c9cb3a5e8d5493060f173ad92f773e804d6ba03b0e0f6fa607b57642b447"

  bottle do
    rebuild 1
    sha256 "a3c41056e62e92756366845ea2c8edd548a55a5b29887f310e668ab6cd749ffd" => :catalina
    sha256 "8d50a624839fff2dea6424b18549e0893e028b0233b64ee18a3bbdfe5523aca2" => :mojave
    sha256 "d5d9aba84c98e71d848532723c74fbdfb616306d39ba696f89001e88b6837b3e" => :high_sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make"
    system "make", "install"
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system("#{bin}/monetdbd", "create", "#{testpath}/dbfarm")
    assert_predicate testpath/"dbfarm", :exist?
  end
end
