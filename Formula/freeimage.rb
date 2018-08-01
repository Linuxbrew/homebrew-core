# freeimage: Build a bottle for Linuxbrew
class Freeimage < Formula
  desc "Library for FreeImage, a dependency-free graphics library"
  homepage "https://sourceforge.net/projects/freeimage"
  url "https://downloads.sourceforge.net/project/freeimage/Source%20Distribution/3.18.0/FreeImage3180.zip"
  version "3.18.0"
  sha256 "f41379682f9ada94ea7b34fe86bf9ee00935a3147be41b6569c9605a53e438fd"

  bottle do
    cellar :any
    sha256 "f3372b5ce748afa7c99da67a593c3e1f112b5aa4b28b36da6a17ee4428158c68" => :high_sierra
    sha256 "24423414222aa7c629f53aadeef266a1e7f3aa50e4138f4a876eadaba634d6c6" => :sierra
    sha256 "cf6a38a128929d3202ffbca5443ee07268d2de2360126353449b698e56830e15" => :el_capitan
    sha256 "62b5cf37deaf4cae92143839f28ae7265cc6966812853797723fb8554069c3e7" => :x86_64_linux
  end

  patch do
    if OS.mac?
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/4dcf528/freeimage/3.17.0.patch"
      sha256 "8ef390fece4d2166d58e739df76b5e7996c879efbff777a8a94bcd1dd9a313e2"
    else
      url "https://gist.githubusercontent.com/davydden/5a4f348108d3c9110299/raw/3396840ff71c639d848ce552de9124462777ab97/freeimage.patch"
      sha256 "537a4045d31a3ce1c3bab2736d17b979543758cf2081e97fff4d72786f1830dc"
    end
  end

  def install
    system "make", "-f", "Makefile.gnu"
    system "make", "-f", "Makefile.gnu", "install", "PREFIX=#{prefix}"
    system "make", "-f", "Makefile.fip"
    system "make", "-f", "Makefile.fip", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <FreeImage.h>
      int main() {
         FreeImage_Initialise(0);
         FreeImage_DeInitialise();
         exit(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lfreeimage", "-o", "test"
    system "./test"
  end
end
