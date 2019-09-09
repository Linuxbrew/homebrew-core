class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://downloads.sourceforge.net/project/ipmitool/ipmitool/1.8.18/ipmitool-1.8.18.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ipmitool/ipmitool_1.8.18.orig.tar.bz2"
  sha256 "0c1ba3b1555edefb7c32ae8cd6a3e04322056bc087918f07189eeedfc8b81e01"
  revision 3

  bottle do
    cellar :any
    sha256 "3bf8d00d62c2e1dc781493d448062ad365ac8e7c73010ee37ba2040a48513c10" => :mojave
    sha256 "04462f0b4129d34cbf7e8e5c72591360e89dd6d6cef20008567015d57ab611c4" => :high_sierra
    sha256 "f08f0e5717ff8ccf031ca738eb4995b39db5d37b802800b6e0b6c154f6fed830" => :sierra
  end

  depends_on "openssl@1.1"

  # https://sourceforge.net/p/ipmitool/bugs/433/#89ea and
  # https://sourceforge.net/p/ipmitool/bugs/436/ (prematurely closed):
  # Fix segfault when prompting for password
  # Re-reported 12 July 2017 https://sourceforge.net/p/ipmitool/mailman/message/35942072/
  patch do
    url "https://gist.githubusercontent.com/adaugherity/87f1466b3c93d5aed205a636169d1c58/raw/29880afac214c1821e34479dad50dca58a0951ef/ipmitool-getpass-segfault.patch"
    sha256 "fc1cff11aa4af974a3be191857baeaf5753d853024923b55c720eac56f424038"
  end

  # Patch for compatibility with OpenSSL 1.1.1
  # https://reviews.freebsd.org/D17527
  patch :p1, :DATA

  def install
    # Fix ipmi_cfgp.c:33:10: fatal error: 'malloc.h' file not found
    # Upstream issue from 8 Nov 2016 https://sourceforge.net/p/ipmitool/bugs/474/
    inreplace "lib/ipmi_cfgp.c", "#include <malloc.h>", ""

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-intf-usb
    ]
    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
__END__
--- old/src/plugins/lanplus/lanplus_crypt_impl.c	2016-05-28 10:20:20.000000000 +0200
+++ new/src/plugins/lanplus/lanplus_crypt_impl.c	2017-02-21 10:50:21.634873466 +0100
@@ -164,10 +164,10 @@ lanplus_encrypt_aes_cbc_128(const uint8_
 							uint8_t       * output,
 							uint32_t        * bytes_written)
 {
-	EVP_CIPHER_CTX ctx;
-	EVP_CIPHER_CTX_init(&ctx);
-	EVP_EncryptInit_ex(&ctx, EVP_aes_128_cbc(), NULL, key, iv);
-	EVP_CIPHER_CTX_set_padding(&ctx, 0);
+	EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
+	EVP_CIPHER_CTX_init(ctx);
+	EVP_EncryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv);
+	EVP_CIPHER_CTX_set_padding(ctx, 0);
 	
 
 	*bytes_written = 0;
@@ -191,7 +191,7 @@ lanplus_encrypt_aes_cbc_128(const uint8_
 	assert((input_length % IPMI_CRYPT_AES_CBC_128_BLOCK_SIZE) == 0);
 
 
-	if(!EVP_EncryptUpdate(&ctx, output, (int *)bytes_written, input, input_length))
+	if(!EVP_EncryptUpdate(ctx, output, (int *)bytes_written, input, input_length))
 	{
 		/* Error */
 		*bytes_written = 0;
@@ -201,7 +201,7 @@ lanplus_encrypt_aes_cbc_128(const uint8_
 	{
 		uint32_t tmplen;
 
-		if(!EVP_EncryptFinal_ex(&ctx, output + *bytes_written, (int *)&tmplen))
+		if(!EVP_EncryptFinal_ex(ctx, output + *bytes_written, (int *)&tmplen))
 		{
 			*bytes_written = 0;
 			return; /* Error */
@@ -210,7 +210,8 @@ lanplus_encrypt_aes_cbc_128(const uint8_
 		{
 			/* Success */
 			*bytes_written += tmplen;
-			EVP_CIPHER_CTX_cleanup(&ctx);
+			EVP_CIPHER_CTX_cleanup(ctx);
+			EVP_CIPHER_CTX_free(ctx);
 		}
 	}
 }
@@ -239,10 +240,10 @@ lanplus_decrypt_aes_cbc_128(const uint8_
 							uint8_t       * output,
 							uint32_t        * bytes_written)
 {
-	EVP_CIPHER_CTX ctx;
-	EVP_CIPHER_CTX_init(&ctx);
-	EVP_DecryptInit_ex(&ctx, EVP_aes_128_cbc(), NULL, key, iv);
-	EVP_CIPHER_CTX_set_padding(&ctx, 0);
+	EVP_CIPHER_CTX *ctx = EVP_CIPHER_CTX_new();
+	EVP_CIPHER_CTX_init(ctx);
+	EVP_DecryptInit_ex(ctx, EVP_aes_128_cbc(), NULL, key, iv);
+	EVP_CIPHER_CTX_set_padding(ctx, 0);
 
 
 	if (verbose >= 5)
@@ -266,7 +267,7 @@ lanplus_decrypt_aes_cbc_128(const uint8_
 	assert((input_length % IPMI_CRYPT_AES_CBC_128_BLOCK_SIZE) == 0);
 
 
-	if (!EVP_DecryptUpdate(&ctx, output, (int *)bytes_written, input, input_length))
+	if (!EVP_DecryptUpdate(ctx, output, (int *)bytes_written, input, input_length))
 	{
 		/* Error */
 		lprintf(LOG_DEBUG, "ERROR: decrypt update failed");
@@ -277,7 +278,7 @@ lanplus_decrypt_aes_cbc_128(const uint8_
 	{
 		uint32_t tmplen;
 
-		if (!EVP_DecryptFinal_ex(&ctx, output + *bytes_written, (int *)&tmplen))
+		if (!EVP_DecryptFinal_ex(ctx, output + *bytes_written, (int *)&tmplen))
 		{
 			char buffer[1000];
 			ERR_error_string(ERR_get_error(), buffer);
@@ -290,7 +291,8 @@ lanplus_decrypt_aes_cbc_128(const uint8_
 		{
 			/* Success */
 			*bytes_written += tmplen;
-			EVP_CIPHER_CTX_cleanup(&ctx);
+			EVP_CIPHER_CTX_cleanup(ctx);
+			EVP_CIPHER_CTX_free(ctx);
 		}
 	}
