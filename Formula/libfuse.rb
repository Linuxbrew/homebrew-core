class Libfuse < Formula
  desc "Reference implementation of the Linux FUSE interface"
  homepage "https://github.com/libfuse/libfuse"
  url "https://github.com/libfuse/libfuse/archive/fuse_2_9_5.tar.gz"
  sha256 "ccea9c00f7572385e9064bc55b2bfefd8d34de487ba16d9eb09672202b5440ec"
  head "https://github.com/libfuse/libfuse.git"
  # tag "linuxbrew"

  bottle do
    sha256 "1c29503e1008d72d58bc2d6efc4ac38500116b3f5794f4aaf16b81afb25827d9" => :x86_64_linux # glibc 2.19
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext"

  def install
    cp Formula["gettext"].pkgshare/"config.rpath", "."
    system "./makeconf.sh"
    ENV["MOUNT_FUSE_PATH"] = "#{sbin}/"
    ENV["UDEV_RULES_PATH"] = "#{etc}/udev/rules.d"
    ENV["INIT_D_PATH"] = "#{etc}/init.d"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"fuse-test.c").write <<~EOS
      #define FUSE_USE_VERSION 26
      #include <fuse.h>
      static struct fuse_operations ops = {
        .init = NULL,
      };
      int main(int argc, char** argv) {
        umask(0);
        return fuse_main(argc, argv, &ops, NULL);
      }
    EOS
    system ENV.cc, "fuse-test.c", "-L#{lib}", "-I#{include}", "-D_FILE_OFFSET_BITS=64", "-lfuse", "-o", "fuse-test"
    output = shell_output("patchelf --print-needed fuse-test").chomp
    assert_equal "libfuse.so.2\nlibc.so.6", output
  end
end
