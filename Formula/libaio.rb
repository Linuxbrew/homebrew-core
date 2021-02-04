class Libaio < Formula
  desc "Linux-native asynchronous I/O access library"
  homepage "https://pagure.io/libaio"
  url "https://pagure.io/libaio/archive/libaio-0.3.112/libaio-libaio-0.3.112.tar.gz"
  sha256 "b7cf93b29bbfb354213a0e8c0e82dfcf4e776157940d894750528714a0af2272"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d1c96633565fcbe50ea9bf4fd68a91b9cc9f65c086e9d3ab3d4c73cc85b5d7a"
  end

  depends_on :linux

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libaio.h>

      int main(int argc, char *argv[])
      {
        struct io_event *event;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laio", "-o", "test"
    system "./test"
  end
end
