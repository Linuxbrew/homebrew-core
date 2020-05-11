class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-04-12.tar.xz"
  sha256 "22b15f2cc910289821379dc8d314d35ef492f6d69d4419c9bcb1b2263e9d71c8"

  bottle do
    sha256 "05d2f8998a2fd13bb606e0bb74d3eef3a0b80977edf6e543b98fd0320715733d" => :catalina
    sha256 "4c7dc36152c0a7d04ab3be8ef7f22c91332816dada0a1c66ad87df3537237dd7" => :mojave
    sha256 "49747bbada54cb4b97c218a5fbc202247a0820e5c7f6f9ccaf7001b7581a3fdc" => :high_sierra
    sha256 "6354cf6567968e5aa2248da36014894f0b55467ea48d2a8a143bd2ed3833c537" => :x86_64_linux
  end

  # Fix build on macOS
  # Alredy reported to upstream https://www.freelists.org/post/quickjs-devel/Latest-version-fails-to-build-on-macOS
  patch :p0, :DATA

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match /^QJS42/, output

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end

__END__
--- quickjs-libc.c
+++ quickjs-libc.c
@@ -46,8 +46,10 @@
 #include <sys/ioctl.h>
 #include <sys/wait.h>
 #if defined(__APPLE__)
 typedef sig_t sighandler_t;
+#include <crt_externs.h>
+#define environ (*_NSGetEnviron ())
 #endif
 #endif

 #include "cutils.h"
