class Libsasl2 < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://www.cyrusimap.org/releases/cyrus-sasl-2.1.27.tar.gz"
  sha256 "26866b1549b00ffd020f188a43c258017fa1c382b3ddadd8201536f72efb05d5"

  bottle do
    sha256 "fea25c321868478ed2bab0788a188e87d00d90bf423f7c4c11161bcca9eda3b5" => :x86_64_linux
  end

  depends_on :linux
  depends_on "openssl@1.1"

  def install
    # Deparallelize, else we get weird build errors
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sasl.h>
      int main(void) {
      }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}",
           "-I#{Formula["libsasl2"].include}/sasl",
           "-lsasl2", "-o", "test", "test.cpp"
    system "./test"
  end
end
