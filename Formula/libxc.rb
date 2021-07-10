class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.1.5/libxc-5.1.5.tar.bz2"
  sha256 "60d9ead0f62e40991b6ff043242902090141c437343eb345a981ec8e3fd224d8"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d7ebe8ece0132ef0dcaf3acc5bf34d01f937409d955a01589403d30f53a0082c"
    sha256 cellar: :any,                 big_sur:       "40e57e0cd88761019d4c8448193c7d3c3cbd298266b6d0b5a85b9c4194ce933e"
    sha256 cellar: :any,                 catalina:      "e54b76bee4a7e70bb69193b7841c8fcc7e90baafb855d59ed7686e67faf044b4"
    sha256 cellar: :any,                 mojave:        "2ee0c09cfc39c2ab530bb432a80143c6ffa858df0aa8e8677442d6b179736f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cedfd3e3bcbb4088d8a00ad08fa26e65f84ff9b18ea50e02a7bf5421582cf9a" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=gfortran -E -x c",
                          "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
