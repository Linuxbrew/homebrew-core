class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  revision 4

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "93f7e02d005fb22101eab93659f200ed8376130c9a4bad0c24b0cdde51b92f18" => :mojave
    sha256 "43347c63d9fb4a6746929b2127453241cdad9b13a9fd00ddf82af418d6a175b2" => :high_sierra
    sha256 "ebf70558240b3cc3c49994e865108d7d29796c45d1129e844ef1c99d8ae510a7" => :sierra
    sha256 "39f94b870bd72b1ff1c76dcb92f087ce93257554f1749206a619f0227de7644c" => :x86_64_linux
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
