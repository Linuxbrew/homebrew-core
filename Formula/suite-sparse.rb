class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "http://faculty.cse.tamu.edu/davis/suitesparse.html"
  url "http://faculty.cse.tamu.edu/davis/SuiteSparse/SuiteSparse-4.5.5.tar.gz"
  sha256 "b9a98de0ddafe7659adffad8a58ca3911c1afa8b509355e7aa58b02feb35d9b6"
  revision 1

  bottle do
    cellar :any
    sha256 "04927e85ebcc7a550d399b39cb773206e380b3d26ddb1d35f4d2e6f88e6f36ea" => :sierra
    sha256 "df8fa69e0bedbce60be7de8c19a5164eadf51f3bdf31dc1561c2edd688a9ad2e" => :el_capitan
    sha256 "cf849ee340a48be83e92ed588bf66cc9f0f817978dd147456ff7186fbf39d5a8" => :yosemite
    sha256 "6fe72b603f059437e58d405ee94cdd3faa9be9c8148022326761c6e8e5ba470e" => :x86_64_linux # glibc 2.19
  end

  depends_on "metis"
  depends_on "openblas" => (OS.mac? ? :optional : :recommended)

  def install
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
