class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.5.3.tar.gz"
  sha256 "66730afc62aa9c9f93ef686998a5396f8721edca3750097d4a2848a688d55bf9"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    cellar :any
    sha256 "28a606466256bf030942104c0e7b5618b442ecee7bcd7498cfac9f2cbb098ebc" => :catalina
    sha256 "e45a56ff580b67b3a17407996d72768b57f06b6f7878ca8320dc8befe8f2793f" => :mojave
    sha256 "583bdc22413565285d5f3551be33c17d12e18a25b665e57076332147cfb283d9" => :high_sierra
    sha256 "74c705c7fca82997ad4371df1d8971f644fc437f359a29a4ce7458b34e13bcd4" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"jlogtest.c").write <<~EOS
      #include <stdio.h>
      #include <jlog.h>
      int main() {
        jlog_ctx *ctx;
        const char *path = "#{testpath}/jlogexample";
        int rv;

        // First, ensure that the jlog is created
        ctx = jlog_new(path);
        if (jlog_ctx_init(ctx) != 0) {
          if(jlog_ctx_err(ctx) != JLOG_ERR_CREATE_EXISTS) {
            fprintf(stderr, "jlog_ctx_init failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
            exit(1);
          }
          // Make sure it knows about our subscriber(s)
          jlog_ctx_add_subscriber(ctx, "one", JLOG_BEGIN);
          jlog_ctx_add_subscriber(ctx, "two", JLOG_BEGIN);
        }

        // Now re-open for writing
        jlog_ctx_close(ctx);
        ctx = jlog_new(path);
        if (jlog_ctx_open_writer(ctx) != 0) {
           fprintf(stderr, "jlog_ctx_open_writer failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
           exit(0);
        }

        // Send in some data
        rv = jlog_ctx_write(ctx, "hello\\n", strlen("hello\\n"));
        if (rv != 0) {
          fprintf(stderr, "jlog_ctx_write_message failed: %d %s\\n", jlog_ctx_err(ctx), jlog_ctx_err_string(ctx));
        }
        jlog_ctx_close(ctx);
      }
    EOS
    system ENV.cc, "jlogtest.c", "-I#{include}", "-L#{lib}", "-ljlog", "-o", "jlogtest"
    system testpath/"jlogtest"
  end
end
