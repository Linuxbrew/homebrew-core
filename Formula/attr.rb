class Attr < Formula
  desc "Manipulate filesystem extended attributes"
  homepage "https://savannah.nongnu.org/projects/attr"
  url "https://download.savannah.nongnu.org/releases/attr/attr-2.5.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/nongnu/attr/attr-2.5.1.tar.gz"
  sha256 "bae1c6949b258a0d68001367ce0c741cebdacdd3b62965d17e5eb23cd78adaf8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/attr/"
    regex(/href=.*?attr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "ee008a3dc86478020116d2289fc6d78dfc44d87a95b7c12c6777e8ed6b053242"
    sha256               x86_64_linux:  "a3360d8260090cdc7efd91f7866b2b0d1f7ae0d0a3344754d0502bd0df80615b"
  end

  depends_on "gettext" => :build
  depends_on :linux

  def install
    system "./configure",
           "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    system bin/"attr", "-s", "name", "test.txt"
    assert_match 'Attribute "name" has a 0 byte value for test.txt',
                 shell_output(bin/"attr -l test.txt")
  end
end
