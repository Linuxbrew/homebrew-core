class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/archive/v4.7.1.tar.gz"
  sha256 "6ed2130eed7b741df3b19052b29b3324601403581c7b9afb015e0370e299a2bd"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/homebrew-shtools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cc5c0cf89291f3b8add63f05e12a90875a953b02fc3273ef81b0d7103cfcb32" => :catalina
    sha256 "b2f7e074fa7ecea8d703c96201de2301682cfcb3dd7d1b781f1e2a2e1c75ad8a" => :mojave
    sha256 "efa5d3314011b1483184edca0ec6b7eedbfc3f132aa613c58d04b5936338b424" => :high_sierra
  end

  depends_on "fftw"
  depends_on "gcc"

  def install
    system "make", "fortran"
    system "make", "fortran-mp"

    pkgshare.install "examples/fortran/", "examples/ExampleDataFiles/"

    lib.install "lib/libSHTOOLS.a", "lib/libSHTOOLS-mp.a"
    include.install "include/fftw3.mod", "include/planetsconstants.mod", "include/shtools.mod", "include/ftypes.mod"
    share.install "man"
  end

  test do
    cp_r pkgshare, testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   *("LAPACK=-framework accelerate" if OS.mac?),
                   "BLAS="
  end
end
