class Libmnl < Formula
  desc "Minimalistic user-space library oriented to Netlink developers"
  homepage "https://www.netfilter.org/projects/libmnl"
  url "git://git.netfilter.org/libmnl",
    :tag      => "libmnl-1.0.4",
    :revision => "0930a63252958f40bb0f9d09de86985c25cea039"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2ea8cee83f8849eb17544ebe72cd17316433cdbf18f9401dab2382bdcf41091" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <time.h>

      #include <libmnl/libmnl.h>
      #include <linux/netlink.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[MNL_SOCKET_BUFFER_SIZE];
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
