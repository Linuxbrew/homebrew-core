class LibcapNg < Formula
  desc "Library for Linux that makes using posix capabilities easy"
  homepage "https://people.redhat.com/sgrubb/libcap-ng"
  url "https://github.com/stevegrubb/libcap-ng/archive/v0.7.10.tar.gz"
  sha256 "c3c156a215e5be5430b2f3b8717bbd1afdabe458b6068a8d163e71cefe98fc32"
  # tag "linux"

  bottle do
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "swig" => :build
  depends_on "python" => :build
  depends_on "m4" => :build

  # undefined reference to `pthread_atfork'
  # https://github.com/stevegrubb/libcap-ng/pull/10
  patch do
    url "https://github.com/stevegrubb/libcap-ng/commit/b4e3cb9cb74aa5d33ad21a988a1463d75b159b77.patch"
    sha256 "d414dd225d069a86f34313619eeabf287c6b153d97c4a6554b5840c1ccdbebc1"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-python3"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <cap-ng.h>

      int main(int argc, char *argv[])
      {
        if(capng_have_permitted_capabilities() > -1)
          printf("ok");
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcap-ng", "-o", "test"
    assert_equal "ok", `./test`
  end
end
