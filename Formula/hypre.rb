class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "541fcb1adc778e587e3f8993bdf7d6c7fabf026ed2256af0e8a4fc64d831f9ec" => :sierra
    sha256 "a610e8ee47f8962ff959e8223d44f87320303144690458550264bceb016464cc" => :el_capitan
    sha256 "e228abcdbeeed01a30b13f1471cb848d309fc306a861d745338b71451374e032" => :yosemite
  end

  option "without-accelerate", "Build without Accelerate framework (use internal BLAS routines)"

  depends_on "veclibfort" if build.without?("openblas") && OS.mac?
  depends_on :fortran
  depends_on :mpi => [:cc, :cxx, :f90, :f77]
  depends_on "openblas" => :recommended unless OS.mac?

  def install
    cd "src" do
      config_args = ["--prefix=#{prefix}"]

      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]

      if build.with? "openblas"
        config_args += ["--with-blas=yes",
                        "--with-blas-libs=openblas",
                        "--with-blas-lib-dirs=#{Formula["openblas"].opt_lib}",
                        "--with-lapack=yes",
                        "--with-lapack-libs=openblas",
                        "--with-lapack-lib-dirs=#{Formula["openblas"].opt_lib}"]
      elsif build.with? "accelerate"
        config_args += ["--with-blas=yes",
                        "--with-blas-libs=blas cblas",
                        "--with-blas-lib-dirs=/usr/lib",
                        "--with-lapack=yes",
                        "--with-lapack-libs=lapack clapack f77lapack",
                        "--with-lapack-lib-dirs=/usr/lib"]
      end

      if OS.linux?
        # on Linux Homebrew formulae will fail to build
        # shared libraries without the dependent static libraries
        # compiled with -fPIC
        ENV.prepend "CFLAGS", "-fPIC"
        ENV.prepend "CXXFLAGS", "-fPIC"
        ENV.prepend "FFLAGS", "-fPIC"
      end

      # MPI library strings for linking depends on compilers
      # enabled.  Only the C library strings are needed (without the
      # lib), because hypre is a C library.
      config_args += ["--with-MPI",
                      "--with-MPI-include=#{HOMEBREW_PREFIX}/include",
                      "--with-MPI-lib-dirs=#{HOMEBREW_PREFIX}/lib",
                      "--with-MPI-libs=mpi"]
      config_args << "--enable-bigint"
      system "./configure", *config_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
