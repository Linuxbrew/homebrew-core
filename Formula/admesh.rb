class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.3/admesh-0.98.3.tar.gz"
  sha256 "b349c835383b6648fd159e528a530fdcb31aed95024d7a294280ac8096ec7624"

  bottle do
    cellar :any
    sha256 "3de4fbc48e0d5ca620bb5fa9cb20d18065fa00fa0c007109473bd495e17686d1" => :sierra
    sha256 "a2de7016b2356c0e2e860c80999bd27edd9967fb85069ed33c60b9dcd35f725b" => :el_capitan
    sha256 "3f3db422de01a8e239d7ef6027d0264d3857feac781ef739072b6ec0d50894a0" => :yosemite
    sha256 "82c1eb21afce86af1d1040b647f8248a931e4e5fcf960be17e52dd39f7be321f" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<-EOS.undent
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "#{bin}/admesh", "test.stl"
  end
end
