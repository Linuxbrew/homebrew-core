class Calceph < Formula
  desc "C library to access the binary planetary ephemeris files"
  homepage "https://www.imcce.fr/inpop/calceph"
  url "https://www.imcce.fr/content/medias/recherche/equipes/asd/calceph/calceph-3.4.4.tar.gz"
  sha256 "d65d83fbddc9f940ead3d5bb59a15b6e939f040a0eed5c5d36f388f00a4647ba"

  bottle do
    cellar :any
    sha256 "a802022cd32748bace434c30ee3158b0d7f881611910499b86ff9139db35a736" => :catalina
    sha256 "f851c7aba23bd20b4a589c74a9e61d82968f9a7898193ac2d9b289bb3605f9ca" => :mojave
    sha256 "7486d6888b3b78219d2e804e1a929b183152f069ea394652ccd4fc7bda41fc67" => :high_sierra
    sha256 "e92583eae9861f37d5e69c1f91f94fb273861e7046d2497cd967baacbe93173c" => :x86_64_linux
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"testcalceph.c").write <<~EOS
      #include <calceph.h>
      #include <assert.h>

      int errorfound;
      static void myhandler (const char *msg) {
        errorfound = 1;
      }

      int main (void) {
        errorfound = 0;
        calceph_seterrorhandler (3, myhandler);
        calceph_open ("example1.dat");
        assert (errorfound==1);
        return 0;
      }
    EOS
    system ENV.cc, "testcalceph.c", "-L#{lib}", "-lcalceph", "-o", "testcalceph"
    system "./testcalceph"
  end
end
