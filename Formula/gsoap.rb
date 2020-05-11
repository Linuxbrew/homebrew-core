class Gsoap < Formula
  desc "SOAP stub and skeleton compiler for C and C++"
  homepage "https://www.genivia.com/products.html"
  url "https://downloads.sourceforge.net/project/gsoap2/gsoap-2.8/gsoap_2.8.102.zip"
  sha256 "c7efad78caa4d41d1ec9762c1ac62a7e8d5a556c50c0b9d72b60cbd84aae6d10"

  bottle do
    sha256 "fa54b1482737b03307665d9c898bfaf9227ade520c180a92ade71b89d3e95928" => :catalina
    sha256 "c226f22f9414e1023976e1e6d1bd6bb5c4f0578f6949eb7ff517af8fdf723c66" => :mojave
    sha256 "d08d517d579647ce1e6945b234824362f8ee1f05e010534e888cfc9952d1665b" => :high_sierra
    sha256 "ecddd0c73faa8f45dccaf3020efc11239aed9cd02e8c70c9d62f2a6550d02173" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "zlib"

  def install
    # Contacted upstream by email and been told this should be fixed by 2.8.37,
    # it is due to the compilation of symbol2.c and soapcpp2_yacc.h not being
    # ordered correctly in parallel. However, issue persists as of 2.8.89.
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/wsdl2h", "-o", "calc.h", "https://www.genivia.com/calc.wsdl"
    system "#{bin}/soapcpp2", "calc.h"
    assert_predicate testpath/"calc.add.req.xml", :exist?
  end
end
