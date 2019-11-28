# oniguruma: Build a bottle for Linux
class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.3/onig-6.9.3.tar.gz"
  sha256 "ab5992a76b7ab2185b55f3aacc1b0df81132c947b3d594f82eb0b41cf219725f"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "06193af02210587ee2b6d63fcf5f18fda46ba84cb21143b5f5b12abb456ff3ec" => :catalina
    sha256 "ed28f2729bacc662f624254a442a90219ee885a8ef1c9241542c4a8ec55c15b9" => :mojave
    sha256 "4dc26cf4626173982cca426a550d1554416d099505537666da01fba148aa8f13" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
