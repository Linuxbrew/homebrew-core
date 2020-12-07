class Libosip < Formula
  desc "Implementation of the eXosip2 stack"
  homepage "https://www.gnu.org/software/osip/"
  url "https://ftp.gnu.org/gnu/osip/libosip2-5.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/osip/libosip2-5.2.0.tar.gz"
  sha256 "4fb48b2ea568bb41c6244b0df2bb7175849ca93e84be53ceb268fdf9351bb375"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/href=.*?libosip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "8f5c5fdfede2252824de6af7f2119dc78a95533c79ca0862d986c98bb3015f6f" => :big_sur
    sha256 "b30669557e92f7ce26fb327cbb2aae10549d296c56448965f26d4057968ef0c9" => :arm64_big_sur
    sha256 "c23d056597896c51c2f364b06b7843c2998931429cefaa5413aa05e57fedef9c" => :catalina
    sha256 "d1f91870b64ffd2b286d76ee44af1f1f7bd94749141110cbfd5de8d327a72e40" => :mojave
    sha256 "d1241b9bbcbacff0a2823b3d1a96ebeb36bc3176b8f18542b9a1cf595900c94f" => :high_sierra
    sha256 "315146c98b4b9be1b9f543feb3ef900712c24c28796340ae3b4995784bc8bfd7" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/time.h>
      #include <osip2/osip.h>

      int main() {
          osip_t *osip;
          int i = osip_init(&osip);
          if (i != 0)
            return -1;
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-losip2", "-o", "test"
    system "./test"
  end
end
