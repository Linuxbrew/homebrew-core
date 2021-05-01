class LibnetfilterQueue < Formula
  desc "Userspace API to packets queued by the kernel packet filter"
  homepage "https://www.netfilter.org/projects/libnetfilter_queue"
  url "https://www.netfilter.org/projects/libnetfilter_queue/files/libnetfilter_queue-1.0.5.tar.bz2"
  sha256 "f9ff3c11305d6e03d81405957bdc11aea18e0d315c3e3f48da53a24ba251b9f5"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3e3aa6338ec45a13632db538ae9e98dcfd521ac621f7556a197f070defd50da5"
  end

  depends_on "pkg-config" => :build
  depends_on "libmnl"
  depends_on "libnfnetlink"
  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <errno.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <unistd.h>
      #include <string.h>
      #include <time.h>
      #include <arpa/inet.h>

      #include <libmnl/libmnl.h>
      #include <linux/netfilter.h>
      #include <linux/netfilter/nfnetlink.h>

      #include <linux/types.h>
      #include <linux/netfilter/nfnetlink_queue.h>

      #include <libnetfilter_queue/libnetfilter_queue.h>

      int main(int argc, char *argv[])
      {
        struct mnl_socket *nl;
        char buf[NFQA_CFG_F_MAX];
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmnl", "-o", "test"
  end
end
