class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.0.3/libtirpc-1.0.3.tar.bz2"
  sha256 "86c3a78fc1bddefa96111dd233124c703b22a78884203c55c3e06b3be6a0fd5e"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c093d0948f7794df11cae0a0f0e974e8b0734d46beb2f7977db39d84aa16720" => :x86_64_linux # glibc 2.19
  end

  depends_on "krb5" => :optional

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "#{"--disable-gssapi" if build.without? "krb5"}"
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
