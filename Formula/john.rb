class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a5ccc4400712b8b3ceeb47ac563cc1fa3fa7b4bb60937d3c1d3218cf51f2e4a" => :mojave
    sha256 "7e7f9960b5594da1e110c16613c9271e428d035ca468c3ae48ec4231b45aa2f1" => :high_sierra
    sha256 "a92418e262ea3ca50d92e5677dd2755207d936a31c8042041955235a2907298d" => :sierra
  end

  conflicts_with "john-jumbo", :because => "both install the same binaries"

  patch :DATA if OS.mac? # Taken from MacPorts, tells john where to find runtime files

  def install
    ENV.deparallelize

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", (OS.mac? ? "macosx-x86-64" : "linux-x86-64")

    prefix.install "doc/README"
    doc.install Dir["doc/*"]

    # Only symlink the binary into bin
    libexec.install Dir["run/*"]
    bin.install_symlink libexec/"john"

    # Source code defaults to 'john.ini', so rename
    mv libexec/"john.conf", libexec/"john.ini"
  end
end


__END__
--- a/src/params.h	2012-08-30 13:24:18.000000000 -0500
+++ b/src/params.h	2012-08-30 13:25:13.000000000 -0500
@@ -70,15 +70,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif
 
 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"HOMEBREW_PREFIX/share/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"HOMEBREW_PREFIX/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif
