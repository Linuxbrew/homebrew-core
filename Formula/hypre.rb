# hypre: Build a bottle for Linuxbrew
class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://github.com/hypre-space/hypre/archive/v2.16.0.tar.gz"
  sha256 "33f8a27041e697343b820d0426e74694670f955e21bbf3fcb07ee95b22c59e90"
  head "https://github.com/hypre-space/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f7300641b6af625482d20ce1b0689c3bb62994ba2af30c92fca68271a8ebaf92" => :mojave
    sha256 "cef93684119abac2fbd535ed125779877639e26b7e0304258d285ee39bbfb992" => :high_sierra
    sha256 "0ffe333f6b327977d2c91b192d31b0483b7d0fd7f8b08112874a853f8e591271" => :sierra
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
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
