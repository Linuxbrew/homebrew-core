class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.14.2.tar.gz"
  sha256 "87a04fd05cac20a2ec47094b7d18b96e0651257d8c768ced2ef7db270ecfb9cb"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.mcs.anl.gov/petsc/download/index.html"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "3ef9adf142bd76bc057d3d2424bc05c7123f224753a5cd427c798d592872edd9" => :big_sur
    sha256 "02eddb0f06078ef7b9b1a2f6c50155674f0db334e33eeb77389561d6669be86c" => :arm64_big_sur
    sha256 "e970168ddbf670ca704b6c7cade72cbcc06277d8839bfce72079e7a8e1ea4464" => :catalina
    sha256 "f7a6c876c4cf9ac8cfab0277a60dd2972276b2bcf6bafff71e0f2b99397fd8a0" => :mojave
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"

    on_macos do
      inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/mac/super/", ""
    end

    on_linux do
      if File.readlines("#{lib}/petsc/conf/petscvariables").grep(/#{HOMEBREW_SHIMS_PATH}/o).any?
        inreplace lib/"petsc/conf/petscvariables", "#{HOMEBREW_SHIMS_PATH}/linux/super/", ""
      end
    end
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match /^Norm of error .+, Iterations/, line, "Unexpected output format"
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
