class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.10.tar.gz"
  mirror "https://sources.voidlinux.eu/talloc-2.1.10/talloc-2.1.10.tar.gz"
  sha256 "c985e94bebd6ec2f6af3d95dcc3fcb192a2ddb7781a021d70ee899e26221f619"

  bottle do
    cellar :any
    sha256 "a9c830bacedca452b99f9ff33181fbe170a1a8ee4534b859704ba62ed0de974d" => :sierra
    sha256 "d6ec63f5bf8d85c274aab1bb635efc85284e3c71c908e5c1e7061c939ed814fc" => :el_capitan
    sha256 "4a9e0e1720e4294e4aa31d5c9ac5bc77e2d225a28f6ca8a3bd14fc645e85a7a7" => :yosemite
    sha256 "752aefcb5cc5ae9bdea139ada50c5f6106a283671c0ec9af562fa0912bc81e0c" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "test.c", "-o", "test", "-ltalloc"
    system testpath/"test"
  end
end
