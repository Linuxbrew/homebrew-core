class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-5.1.2.tar.gz"
  sha256 "4ec8d344bd8e95b898132ddffd7ee93bfbb2c1224925d11bab844b08f9b4c3b7"

  bottle do
    cellar :any
    sha256 "af9518194f86d215c7ccaf029afd2a67c6e8b6942db098655634c5565caab7f8" => :high_sierra
    sha256 "2cd19b75d4f5c3069c3d8d4654a5d2de56881f7c900ff363d97093de5058f8fa" => :sierra
    sha256 "03fa4e10462f868f2f8a5115c5f2689ee7196e2f345769dd63d6b60dfa652381" => :el_capitan
    sha256 "f7f73f3720b2662d716d6cbca8e59174afa09a5a1f979e68323543914ca600cb" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  def install
    mkdir "GraphBLAS/build" do
      system "cmake", "..", *std_cmake_args
    end

    args = [
      "INSTALL=#{prefix}",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
    ]
    if build.with? "openblas"
      args << "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas"
    elsif OS.mac?
      args << "BLAS=-framework Accelerate"
    else
      args << "BLAS=-lblas -llapack"
    end
    args << "LAPACK=$(BLAS)"
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
                   "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    system "./test"
  end
end
