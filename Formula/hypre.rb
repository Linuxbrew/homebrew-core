# hypre: Build a bottle for Linuxbrew
class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computation.llnl.gov/casc/hypre/software.html"
  url "https://computation.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods/download/hypre-2.11.2.tar.gz"
  sha256 "25b6c1226411593f71bb5cf3891431afaa8c3fd487bdfe4faeeb55c6fdfb269e"
  revision 3
  head "https://github.com/LLNL/hypre.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b0ee7e6a754e583739aa29b055d812a4d77834c0871e38c38f931731c860818" => :high_sierra
    sha256 "1702f97e71696f76192e2be7719020999810984515e777964053c2f6d2541ddb" => :sierra
    sha256 "9f8162b5b6119c7a1015388a054415c5d77fae6cf37a24b4bd58b7e3d0ef885b" => :el_capitan
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
