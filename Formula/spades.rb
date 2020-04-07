class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.0/SPAdes-3.14.0.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.0/SPAdes-3.14.0.tar.gz"
  sha256 "18988dd51762863a16009aebb6e873c1fbca92328b0e6a5af0773e2b1ad7ddb9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4f619fb90d37233f7fadbba8c9fa30b039145fc93a453a1381dc6386b0e4b2d3" => :catalina
    sha256 "e48a5ee1e9836f3185985e074891a485a14096148babadee818354d0b34a2bdf" => :mojave
    sha256 "b7ab0e7eeaf9f1e48e2b3c54150bea4bfc1322badaf41237bdfc49e8d435e5d7" => :high_sierra
    sha256 "5334d4fb4ff8c5fc9c7bf362c7a33d8ef60ce19f2e0d063e50118931a4b95f91" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libomp" if OS.mac?
  depends_on "python@3.8"

  # Fix cmake error:
  # Performing Test HAVE_CPU_SPINWAIT
  # Performing Test HAVE_CPU_SPINWAIT - Failed
  depends_on "jemalloc" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    # Use libomp due to issues with headers in GCC.
    args = std_cmake_args
    if OS.mac?
      libomp = Formula["libomp"]
      args << "-DOpenMP_C_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_FLAGS=\"-Xpreprocessor -fopenmp -I#{libomp.opt_include}\""
      args << "-DOpenMP_CXX_LIB_NAMES=omp"
      args << "-DOpenMP_C_LIB_NAMES=omp"
      args << "-DOpenMP_omp_LIBRARY=#{libomp.opt_lib}/libomp.dylib"
      args << "-DAPPLE_OUTPUT_DYLIB=ON"
    end

    mkdir "src/build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
