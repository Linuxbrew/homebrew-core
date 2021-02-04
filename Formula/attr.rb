class Attr < Formula
  desc "Manipulate filesystem extended attributes"
  homepage "https://savannah.nongnu.org/projects/attr"
  url "https://download.savannah.nongnu.org/releases/attr/attr-2.4.48.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/nongnu/attr/attr-2.4.48.tar.gz"
  sha256 "5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/attr/"
    regex(/href=.*?attr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "3b9b66637bfe43449338f3c00e2cd44d597f8cc2f94d439fb2d61845096cc1ba"
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
