class Scalapack < Formula
  desc "High-performance linear algebra for distributed memory machines"
  homepage "https://www.netlib.org/scalapack/"
  url "https://www.netlib.org/scalapack/scalapack-2.1.0.tgz"
  sha256 "61d9216cf81d246944720cfce96255878a3f85dec13b9351f1fa0fd6768220a6"
  revision 2

  bottle do
    cellar :any
    sha256 "281e3d5317f1616e8d5a6a3b9c37fbe6ee29a03b2abe14055854902a6c009a87" => :catalina
    sha256 "b222f27ffed17605ffca2d1b0b4804f4c66ec916c9d2b5f2dd085ad2427fa791" => :mojave
    sha256 "ea92d3247883a9e0de28483a34d1ca064d395d28c8a622fbac571f4cd6d0e64d" => :high_sierra
    sha256 "cd8013efd72936bdf7ff55b35659abda6a4f6476bef0884bbf7f989070b9c22d" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  # Patch for compatibility with GCC 10
  patch do
    url "https://github.com/Reference-ScaLAPACK/scalapack/pull/23.diff?full_index=1"
    sha256 "6e97008a0dd8624a63718a0882aa870f31883ec00d7bfac49e9e901979359039"
  end

  def install
    mkdir "build" do
      blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
      system "cmake", "..", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON",
                      "-DBLAS_LIBRARIES=#{blas}", "-DLAPACK_LIBRARIES=#{blas}"
      system "make", "all"
      system "make", "install"
    end

    pkgshare.install "EXAMPLE"
  end

  test do
    cp_r pkgshare/"EXAMPLE", testpath
    cd "EXAMPLE" do
      system "mpif90", "-o", "xsscaex", "psscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xsscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xdscaex", "pdscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xdscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xcscaex", "pcscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xcscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
      system "mpif90", "-o", "xzscaex", "pzscaex.f", "pdscaexinfo.f", "-L#{opt_lib}", "-lscalapack"
      assert `mpirun -np 4 ./xzscaex | grep 'INFO code' | awk '{print $NF}'`.to_i.zero?
    end
  end
end
