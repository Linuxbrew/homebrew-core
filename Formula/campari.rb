class Campari < Formula
  desc "Complete suite for Molecular Dynamics simulation AND analysis"
  homepage "https://campari.sourceforge.io/"
  url "https://gitlab.com/CaflischLab/debcampari/-/archive/master/debcampari-master.tar.gz"
  version "3.0.1"
  sha256 "5b9481030d24741d1b4b5e63b48055fb308b534f403975a8f4c0d2f235577e3b"
  depends_on "automake"
  depends_on "fftw"
  depends_on "gcc"
  depends_on "lapack"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  def install
    Dir.chdir("source")
    system "./configure", "--with-hsl=no",
                          "--enable-mpi",
                          "--enable-threads",
                          "--prefix=#{prefix}"
    system "make", "all_brew"
    Dir.pwd
    Dir.chdir("..")
  end
  test do
    Dir.chdir("examples/tutorial1")
    system "#{bin}/campari", "-k", "TEMPLATE.key"
  end
end
