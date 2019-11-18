class Libsasl2 < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "https://www.cyrusimap.org/releases/cyrus-sasl-2.1.27.tar.gz"
  sha256 "26866b1549b00ffd020f188a43c258017fa1c382b3ddadd8201536f72efb05d5"
  # tag "linux"

  bottle do
  end

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

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-I#{Formula["libsasl2"].include}/sasl", "-lsasl2", "-o", "test", "test.cpp"
    system "./test"
  end
end
