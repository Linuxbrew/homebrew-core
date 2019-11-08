# sundials: Build a bottle for Linux
class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-4.1.0.tar.gz"
  sha256 "280de1c27b2360170a6f46cb3799b2aee9dff3bddbafc8b08c291a47ab258aa5"
  revision 3

  bottle do
    cellar :any
    sha256 "dd4d99ea429ce4c0fd79b84e0e3fb464337772dd831c302fdd083bce764e9f66" => :catalina
    sha256 "7a04b21785634e504c74c2ddd74f23787ff25ed000f04311afaf4a98ec9f9c5a" => :mojave
    sha256 "2448a70d06a0d49d7593614db8d1f1ea1499d4d889c29a6a4a5ce1b21ded2382" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"
  uses_from_macos "m4"
  uses_from_macos "python"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=#{ENV["CC"]}
      -DBUILD_SHARED_LIBS=ON
      -DKLU_ENABLE=ON
      -DKLU_LIBRARY_DIR=#{Formula["suite-sparse"].opt_lib}
      -DKLU_INCLUDE_DIR=#{Formula["suite-sparse"].opt_include}
      -DLAPACK_ENABLE=ON
      -DBLA_VENDOR=OpenBLAS
      -DLAPACK_LIBRARIES=#{blas};#{blas}
      -DMPI_ENABLE=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    cp Dir[prefix/"examples/nvector/serial/*"], testpath
    args = %w[
      -I#{include}
      test_nvector.c
      sundials_nvector.c
      test_nvector_serial.c
      -L#{lib}
      -lsundials_nvecserial
    ]
    args << "-lm" if OS.linux?
    system ENV.cc, *args
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end
