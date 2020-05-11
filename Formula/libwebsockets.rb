class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v4.0.7.tar.gz"
  sha256 "531e8f54fb9df64e790a3a62ace103dfbd67d2e3994745623422f89fbb7abcaf"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "ffffc984d47b2e10c76f61457eebaedf88ddba86861c552e7e0efe594dd01696" => :catalina
    sha256 "a2a1a550ca86126fc1909457833c4a6e41a38ed9e32dd9a10dd759eada6661aa" => :mojave
    sha256 "111d919aa5372e825941f9b864d40d73e0f2c3678a80c2ee6a667798cb9bb964" => :high_sierra
    sha256 "80474e7e96ab1206652e7a596f3bbeab4e4d1358bfc1fa4ee2acd84a7c446787" => :x86_64_linux
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
