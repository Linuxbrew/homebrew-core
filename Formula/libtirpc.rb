class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.3/libtirpc-1.0.3.tar.bz2"
  sha256 "251a85b3bac687974f360d3796048c20ded3bf0bd69e0d1cfd1db23d013f89ed"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c093d0948f7794df11cae0a0f0e974e8b0734d46beb2f7977db39d84aa16720" => :x86_64_linux # glibc 2.19
  end

  depends_on "krb5"

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/des_crypt.h>
      #include <stdio.h>
      int main () {
        char key[] = "My8digitkey1234";
        if (sizeof(key) != 16)
          return 1;
        des_setparity(key);
        printf("%d\\n", sizeof(key));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
