class Sundials < Formula
  desc "Nonlinear and differential/algebraic equations solver"
  homepage "https://computation.llnl.gov/casc/sundials/main.html"
  url "https://computation.llnl.gov/projects/sundials/download/sundials-5.3.0.tar.gz"
  sha256 "88dff7e11a366853d8afd5de05bf197a8129a804d9d4461fb64297f1ef89bca7"

  bottle do
    cellar :any
    sha256 "ce7631fff95a27b2a1b3aaae734f787b237e2ae123a3c79ed6c2867c8bd78b0c" => :catalina
    sha256 "4803df32afafb0aee71c4f1a299541bb09f1da7f7bcd6798274613d03b2e7d0f" => :mojave
    sha256 "3d2a4408fb64c0ffa3c593556a403edc975364df553335b368e8087ff1aca68e" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "suite-sparse"

  uses_from_macos "libpcap"
  uses_from_macos "m4"

  def install
    blas = "-L#{Formula["openblas"].opt_lib} -lopenblas"
    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=/usr/bin/clang
      -DCMAKE_CXX_COMPILER=/usr/bin/clang++
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
    args = %W[
      -I#{include}
      test_nvector.c
      sundials_nvector.c
      test_nvector_serial.c
      -L#{lib}
      -lsundials_nvecserial
    ]
    args << "-lm" unless OS.mac?
    system ENV.cc, *args
    assert_match "SUCCESS: NVector module passed all tests",
                 shell_output("./a.out 42 0")
  end
end
