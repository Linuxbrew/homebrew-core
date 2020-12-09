class Gmp < Formula
  desc "GNU multiple precision arithmetic library"
  homepage "https://gmplib.org/"
  url "https://gmplib.org/download/gmp/gmp-6.2.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz"
  sha256 "fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gmplib.org/download/gmp/"
    regex(/href=.*?gmp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "6a44705536f25c4b9f8547d44d129ae3b3657755039966ad2b86b821e187c32c" => :big_sur
    sha256 "35e9f82d80708ae8dea2d6b0646dcd86d692321b96effaa76b7fad4d6cffa5be" => :catalina
    sha256 "00fb998dc2abbd09ee9f2ad733ae1adc185924fb01be8814e69a57ef750b1a32" => :mojave
    sha256 "54191ce7fa888df64b9c52870531ac0ce2e8cbd40a7c4cdec74cb2c4a421af97" => :high_sierra
    sha256 "3626da4caca6819effc7a1b35d4a43299cc7574f603a4464b82d9253b6f11faa" => :arm64_big_sur
    sha256 "47ec066627ce0564e7c6b5da2a3311cdcbf09762dce6bad3f0cad46c1377aabc" => :x86_64_linux
  end

  uses_from_macos "m4" => :build

  def install
    # Enable --with-pic to avoid linking issues with the static library
    args = %W[--prefix=#{prefix} --enable-cxx --with-pic]

    if OS.mac?
      cpu = Hardware::CPU.arm? ? "aarch64" : Hardware.oldest_cpu
      args << "--build=#{cpu}-apple-darwin#{OS.kernel_version.major}"
    elsif !OS.mac? && Hardware::CPU.intel?
      args << "--build=core2-linux-gnu"
      args << "ABI=32" if Hardware::CPU.is_32_bit?
    end

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gmp.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lgmp", "-o", "test"
    system "./test"

    # Test the static library to catch potential linking issues
    system ENV.cc, "test.c", "#{lib}/libgmp.a", "-o", "test"
    system "./test"
  end
end
