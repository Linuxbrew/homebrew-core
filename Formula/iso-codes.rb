class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.5.0.orig.tar.xz"
  sha256 "2a63118f8c91faa2102e6381ae498e7fa83b2bdf667963e0f7dbae2a23b827dd"
  license "LGPL-2.1"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "de9e461920f45e7a41272e45c365bc03fce3897a52b14b22b5953967d595e313" => :catalina
    sha256 "de9e461920f45e7a41272e45c365bc03fce3897a52b14b22b5953967d595e313" => :mojave
    sha256 "de9e461920f45e7a41272e45c365bc03fce3897a52b14b22b5953967d595e313" => :high_sierra
    sha256 "adc279ff3b85e5d247f67effc657e561ceaf4119df5ec54caf338664764c34b3" => :x86_64_linux
  end

  depends_on "gettext" => :build
  depends_on "python@3.8" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
