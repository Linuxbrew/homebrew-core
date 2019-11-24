class Attr < Formula
  desc "Manipulate filesystem extended attributes"
  homepage "https://savannah.nongnu.org/projects/attr"
  url "https://mirror.csclub.uwaterloo.ca/nongnu/attr/attr-2.4.48.tar.gz"
  sha256 "5ead72b358ec709ed00bbf7a9eaef1654baad937c001c044fe8b74c57f5324e7"
  # tag "linux"

  bottle do
  end

  depends_on "gettext" => :build

  def install
    # Fix No rule to make target `../libattr/libattr.la', needed by `attr'
    ENV.deparallelize

    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"attr", "-l", "/bin/sh"
  end
end
