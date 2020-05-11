class Jlog < Formula
  desc "Pure C message queue with subscribers and publishers for logs"
  homepage "https://labs.omniti.com/labs/jlog"
  url "https://github.com/omniti-labs/jlog/archive/2.5.0.tar.gz"
  sha256 "776855a212cb95b70f5a18d46e4f68932b8a28a52d47db78665220d38907d45e"
  head "https://github.com/omniti-labs/jlog.git"

  bottle do
    cellar :any
    sha256 "0035c0b7b0c788a3f7ec3d4b58f6f655d2c63074d25bc3bbf95c0705f21f7b06" => :catalina
    sha256 "de25cec1a194a729f38708115666b22f74831705d6935e91351b0dd03ff7418f" => :mojave
    sha256 "cde88254fbdb4a138ce85946825c024e46b9dac01d3a4c4418fd99caac07fb58" => :high_sierra
    sha256 "4ab046817ed42a50309ee9c8a3c04dd9e2573d93246eaf3811009c760acd320f" => :x86_64_linux
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
