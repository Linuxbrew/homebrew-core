class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v5.8.0.tar.gz"
  sha256 "94a9b7134eb4dd82b97f1a22a6b464feb81e73af2dcdf683c6f252285191df1d"

  bottle do
    sha256 "071121481c6eca597812a7b41a4bdf11d334e5d5a3d400b30f685425fb3d3889" => :catalina
    sha256 "28ab445631aec4a86e477a9664c1610e49146add9fc673cfb9528f0c4c1d11a3" => :mojave
    sha256 "161c178cdb17f0ac05e8376756262d8c8e0bd4092b99bac0b45f15d187bd6cd7" => :high_sierra
    sha256 "e7f66050ef485b95683be7d21e38cdad9b3bb27ce6fa9be6d352c52fae7a941e" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"
  depends_on "tbb"

  uses_from_macos "m4"

  conflicts_with "mongoose", :because => "suite-sparse vendors libmongoose.dylib"

  def install
    mkdir "GraphBLAS/build" do
      system "cmake", "..", *std_cmake_args
    end

    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
    ]

    system "make", "library", *args
    unless OS.mac?
      args << "INSTALL_LIB=#{lib}"
      args << "INSTALL_INCLUDE=#{include}"
      args << "DESTDIR=#{prefix}"
    end
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
