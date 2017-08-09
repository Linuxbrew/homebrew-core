class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio3390.tar.gz"
  mirror "ftp://heasarc.gsfc.nasa.gov/software/fitsio/c/cfitsio3390.tar.gz"
  version "3.390"
  sha256 "62d3d8f38890275cc7a78f5e9a4b85d7053e75ae43e988f1e2390e539ba7f409"

  bottle do
    cellar :any
    sha256 "df961ff99786357430032fae6b7e0ae871364dd60edc05ac548f6361ddd60904" => :sierra
    sha256 "29e485f25a51ce580f6547bcd0d05cc517189e8a01881ac21c5e27781ed8230d" => :el_capitan
    sha256 "3d3de057f3f3ae3ff4111a77193871a18ba6b9b1d71a7a68882937f2dccd216a" => :yosemite
    sha256 "b21eee517163d977dca6c7bd1f2de3f4c16d8f14a91b72899df19404887b36e4" => :mavericks
  end

  option "with-examples", "Compile and install example programs"

  resource "examples" do
    url "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/cexamples/cexamples.zip"
    version "2016.04.06"
    sha256 "ed17b6d0f2a3d9858d6b19a073b2479823b37e501b7fd0ef9fa08988ad7ab8fc"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]

    if build.with? "examples"
      system "make", "fpack", "funpack"
      bin.install "fpack", "funpack"

      resource("examples").stage do
        # compressed_fits.c does not work (obsolete function call)
        (Dir["*.c"] - ["compress_fits.c"]).each do |f|
          system ENV.cc, f, "-I#{include}", "-L#{lib}", "-lcfitsio", "-lm", "-o", "#{bin}/#{f.sub(".c", "")}"
        end
      end
    end
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    flags = %W[
      -I#{include}
      -L#{lib}
      -lcfitsio
    ]
    system ENV.cc, "testprog.c", "-o", "testprog", *flags
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
