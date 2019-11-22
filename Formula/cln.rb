# cln: Build a bottle for Linux
class Cln < Formula
  desc "Class Library for Numbers"
  homepage "https://www.ginac.de/CLN/"
  url "https://www.ginac.de/CLN/cln-1.3.5.tar.bz2"
  sha256 "78810064a50b4299a0a3c16cade54a7d2e72ac92a8ee295f9a9177efc81e842d"

  bottle do
    cellar :any
    sha256 "ff06531dfcb6dfd280f878a737422ac31efd895123e3f965c1f0e3b9047e9e7b" => :catalina
    sha256 "39ece0072467407beb6c03a51a12d58ea3d544740e49e13a07424df6a65c09ac" => :mojave
    sha256 "7ebe1b7e5d3f5b4b11125a62933914a4a5abbc8d2d6d43aa9e247b2717ec0c36" => :high_sierra
  end

  depends_on "gmp"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match "3.14159", shell_output("#{bin}/pi 6")
  end
end
