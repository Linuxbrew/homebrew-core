class Neon < Formula
  desc "HTTP and WebDAV client library with a C interface"
  homepage "https://notroj.github.io/neon/"
  url "https://notroj.github.io/neon/neon-0.31.1.tar.gz"
  mirror "https://fossies.org/linux/www/neon-0.31.1.tar.gz"
  sha256 "c9dfcee723050df37ce18ba449d7707b78e7ab8230f3a4c59d9112e17dc2718d"

  bottle do
    cellar :any
    sha256 "bcac044d4f80150fdad61b8fb79a50dc750918cb6d95bf28cdb97d3ee83b131d" => :catalina
    sha256 "ed9208368b808c3e5bae4b4b754f71cc836b0814c8ff6ab0f2c508cb00d0564f" => :mojave
    sha256 "b3920327bff10523afc83dc19a488da3519d78860623718ca0c0cc2611e611ee" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Configure switch unconditionally adds the -no-cpp-precomp switch
  # to CPPFLAGS, which is an obsolete Apple-only switch that breaks
  # builds under non-Apple compilers and which may or may not do anything
  # anymore.
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-static",
                          "--disable-nls",
                          "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end
end

__END__
diff --git a/configure b/configure
index d7702d2..5c3b5a3 100755
--- a/configure
+++ b/configure
@@ -4224,7 +4224,6 @@ fi
 $as_echo "$ne_cv_os_uname" >&6; }

 if test "$ne_cv_os_uname" = "Darwin"; then
-  CPPFLAGS="$CPPFLAGS -no-cpp-precomp"
   LDFLAGS="$LDFLAGS -flat_namespace"
   # poll has various issues in various Darwin releases
   if test x${ac_cv_func_poll+set} != xset; then
