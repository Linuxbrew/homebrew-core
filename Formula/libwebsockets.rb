class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.9.tar.gz"
  sha256 "30ba0fc15898198b23649dc78560f1fa5810b6343964017ffb3d566f279794c2"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "fed020ff32c8c8c76e6718c15786a717c98dc1f2b997b922bbc86e6469cda632" => :catalina
    sha256 "8815f741a3a0a6d6225cbf962bdef941218c543a710c5d5afa4a5eb861a0c71b" => :mojave
    sha256 "0c1991e4396d4b3295aa25ac4f5023403c4c771e60072e3b5f9e89e6a81c8bec" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args,
                    "-DLWS_IPV6=ON",
                    "-DLWS_WITH_HTTP2=ON",
                    "-DLWS_WITH_LIBEVENT=ON",
                    "-DLWS_WITH_LIBUV=ON",
                    "-DLWS_WITH_PLUGINS=ON",
                    "-DLWS_WITHOUT_TESTAPPS=ON",
                    "-DLWS_UNIX_SOCK=ON"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl@1.1"].opt_prefix}/include",
                   "-L#{lib}", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
