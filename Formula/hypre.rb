# hypre: Build a bottle for Linuxbrew
class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  revision 2
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8ae3742bdd41548c214a8ac0a4f139b31beb08d7d2cdffd018fff1875a631ca" => :high_sierra
    sha256 "a696ab2a3732c1b9970a9a09385e9577aede6131f1848b81abdde487139424bb" => :sierra
    sha256 "1b8117394f6f92485112b50678d82360766739bac5f1dc46d7573bfa97232138" => :el_capitan
    sha256 "339f1ccf2f2d9d2e00d942ee61ad42b95c47570ee07e36b89739f35154d901ed" => :x86_64_linux
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "veclibfort" if OS.mac?
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
