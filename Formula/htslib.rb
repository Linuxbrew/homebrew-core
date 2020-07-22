class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "https://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.10.2/htslib-1.10.2.tar.bz2"
  sha256 "e3b543de2f71723830a1e0472cf5489ec27d0fbeb46b1103e14a11b7177d1939"

  bottle do
    cellar :any
    sha256 "4db003ad760c84dbe70dfcd866a32066a4d93980eab12526f69f53e0052d84a6" => :catalina
    sha256 "b4282ee3f330a894e68a0141b13b7fc1327d92a5319a95f5a8107a401e57ece5" => :mojave
    sha256 "507db470fc6cb7d97b06f0efff270fe2063d25143bdc09623135c4876474b3c3" => :high_sierra
    sha256 "e23b394cd0384d8827932c8074a0d5d3a144c0204fd5fbe8a67303b429376821" => :x86_64_linux
  end

  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-libcurl"
    system "make", "install"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert_predicate testpath/"sam.gz", :exist?
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert_predicate testpath/"sam.gz.tbi", :exist?
  end
end


__END__
commit c7c7fb56dba6f81a56a5ec5ea20b8ad81ce62a43
Author: daviesrob <rmd+git@sanger.ac.uk>
Date:   Wed Jul 15 09:03:25 2020 +0100

    Fix hfile_libcurl breakage when using libcurl 7.69.1 or later (#1105)
    
    Curl update https://github.com/curl/curl/pull/5050 (pause: bail out
    on bad input) made curl_easy_pause() return an error if passed
    a disconnected CURL handle.  In hfile_libcurl this could happen
    when libcurl_read() or libcurl_close() was called after all
    bytes had been read; or all the time in restart_from_position().
    
    Fix by checking for fp->finished in libcurl_read() and
    libcurl_close(); and by removing the curl_easy_pause() in
    restart_from_position().
    
    Thanks to @jmarshall for tracking down the exact libcurl change
    that caused the incompatibility.

diff --git a/hfile_libcurl.c b/hfile_libcurl.c
index ffee381..f00fcac 100644
--- a/hfile_libcurl.c
+++ b/hfile_libcurl.c
@@ -221,6 +221,8 @@ static int easy_errno(CURL *easy, CURLcode err)
         return EEXIST;
 
     default:
+        hts_log_error("Libcurl reported error %d (%s)", (int) err,
+                      curl_easy_strerror(err));
         return EIO;
     }
 }
@@ -241,6 +243,8 @@ static int multi_errno(CURLMcode errm)
         return ENOMEM;
 
     default:
+        hts_log_error("Libcurl reported error %d (%s)", (int) errm,
+                      curl_multi_strerror(errm));
         return EIO;
     }
 }
@@ -818,8 +822,13 @@ static ssize_t libcurl_read(hFILE *fpv, void *bufferv, size_t nbytes)
         fp->buffer.ptr.rd = buffer;
         fp->buffer.len = nbytes;
         fp->paused = 0;
-        err = curl_easy_pause(fp->easy, CURLPAUSE_CONT);
-        if (err != CURLE_OK) { errno = easy_errno(fp->easy, err); return -1; }
+        if (!fp->finished) {
+            err = curl_easy_pause(fp->easy, CURLPAUSE_CONT);
+            if (err != CURLE_OK) {
+                errno = easy_errno(fp->easy, err);
+                return -1;
+            }
+        }
 
         while (! fp->paused && ! fp->finished) {
             if (wait_perform(fp) < 0) return -1;
@@ -1046,12 +1055,6 @@ static int restart_from_position(hFILE_libcurl *fp, off_t pos) {
     }
     temp_fp.nrunning = ++fp->nrunning;
 
-    err = curl_easy_pause(temp_fp.easy, CURLPAUSE_CONT);
-    if (err != CURLE_OK) {
-        save_errno = easy_errno(temp_fp.easy, err);
-        goto error_remove;
-    }
-
     while (! temp_fp.paused && ! temp_fp.finished)
         if (wait_perform(&temp_fp) < 0) {
             save_errno = errno;
@@ -1127,8 +1130,10 @@ static int libcurl_close(hFILE *fpv)
     fp->buffer.len = 0;
     fp->closing = 1;
     fp->paused = 0;
-    err = curl_easy_pause(fp->easy, CURLPAUSE_CONT);
-    if (err != CURLE_OK) save_errno = easy_errno(fp->easy, err);
+    if (!fp->finished) {
+        err = curl_easy_pause(fp->easy, CURLPAUSE_CONT);
+        if (err != CURLE_OK) save_errno = easy_errno(fp->easy, err);
+    }
 
     while (save_errno == 0 && ! fp->paused && ! fp->finished)
         if (wait_perform(fp) < 0) save_errno = errno;
