class Libseccomp < Formula
  desc "Interface to the Linux Kernel's syscall filtering mechanism"
  homepage "https://github.com/seccomp/libseccomp"
  url "https://github.com/seccomp/libseccomp/releases/download/v2.4.1/libseccomp-2.4.1.tar.gz"
  sha256 "1ca3735249af66a1b2f762fe6e710fcc294ad7185f1cc961e5bd83f9988006e8"
  # tag "linuxbrew"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ver = version.to_s.split(".")
    ver_major = ver[0]
    ver_minor = ver[1]

    (testpath/"test.c").write <<~EOS
      #include <seccomp.h>
      int main(int argc, char *argv[])
      {
        if(SCMP_VER_MAJOR != #{ver_major})
          return 1;
        if(SCMP_VER_MINOR != #{ver_minor})
          return 1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lseccomp", "-o", "test"
    system "./test"
  end
end
