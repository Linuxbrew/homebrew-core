class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.5/onig-6.9.5.tar.gz"
  sha256 "2f25cc3165e6da4b12dcabdb6b77c48f436d835e127ec2e3cad7abae9ea8e9a6"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    sha256 "d38309153631f9087a3eeb3493e56b414f5c9178172f08d4cb70e7ad7e570509" => :catalina
    sha256 "b5313539e2b51100e1e9c98672a41cb58bdb58c34c09d7227678eedfef4949c5" => :mojave
    sha256 "c1de50154e3ae86545e8df69efafa1e07a03e8171e0215b863179f3ea6f8a2bc" => :high_sierra
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
