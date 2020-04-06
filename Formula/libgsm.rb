class Libgsm < Formula
  desc "Lossy speech compression library"
  homepage "http://www.quut.com/gsm/"
  url "http://www.quut.com/gsm/gsm-1.0.19.tar.gz"
  sha256 "4903652f68a8c04d0041f0d19b1eb713ddcd2aa011c5e595b3b8bca2755270f6"

  bottle do
    cellar :any
    sha256 "9a3eaa556cd1a5429c458ee11c29b5c757ee6f32fbc334355110a37622357dc4" => :catalina
    sha256 "f7a7683ef5f7f916e81e3ed51aa754da92ca2b993533608f8fc95187baaf8b3c" => :mojave
    sha256 "5a2b52e7ed65f005f32bb56519dd425b26e537f888b49402322fe1424f0901e4" => :high_sierra
  end

  if OS.mac?
    # Builds a dynamic library for gsm, this package is no longer developed
    # upstream. Patch taken from Debian and modified to build a dylib.
    patch do
      url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
      sha256 "3b47c28991df93b5c23659011e9d99feecade8f2623762041a5dcc0f5686ffd9"
    end
  else
    patch do
      url "https://gist.githubusercontent.com/iMichka/e481a4ed28b9efcbf77ef6b4cb4ac823/raw/2b22db28d4169c5f51f3f90bcb78ff7382243927/libgms1.0.19"
      sha256 "b95d3586c547ff23e0fffd5aa43effe123d4a7e0198a8d7096d60dd3b9b5ced9"
    end
  end

  def install
    ENV.append_to_cflags "-c -O2 -DNeedFunctionPrototypes=1"

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    # Dynamic library must be built first
    library = OS.mac? ? "libgsm.1.0.13.dylib" : "libgsm.so"
    dylib = OS.mac? ? "dylib" : "so"
    system "make", "lib/#{library}",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}" + (" -fPIC" unless OS.mac?),
           "LDFLAGS=#{ENV.ldflags}" + (" -fPIC" unless OS.mac?)
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir["lib/*#{dylib}"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gsm.h>

      int main()
      {
        gsm g = gsm_create();
        if (g == 0)
        {
          return 1;
        }
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lgsm", "test.c", "-o", "test"
    system "./test"
  end
end
