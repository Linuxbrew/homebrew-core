class Spades < Formula
  desc "De novo genome sequence assembly"
  homepage "http://cab.spbu.ru/software/spades/"
  url "https://github.com/ablab/spades/releases/download/v3.14.1/SPAdes-3.14.1.tar.gz"
  mirror "http://cab.spbu.ru/files/release3.14.1/SPAdes-3.14.1.tar.gz"
  sha256 "d71ce756daa0a889b8881bd129a761200a0bb971e6fd2bed1384a1df9b585d1b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2a3bcd1c2b83517676f45d3381b72e4644beeb98af2add918d8b30271eb8012" => :catalina
    sha256 "a3074628545245497991275ef869a42fa30b465f523fc63c69c37fecdc5e4349" => :mojave
    sha256 "c6d252bcbfe704a634cfbd929d87c003f1c2023abab767db6cd04e2c778c227b" => :high_sierra
    sha256 "f37448145ebe732de8b6359fb4184895fd1aa2eae5e4732ce5bb98f8ada1adc6" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libomp" if OS.mac?
  depends_on "python@3.8"

  # Fix cmake error:
  # Performing Test HAVE_CPU_SPINWAIT
  # Performing Test HAVE_CPU_SPINWAIT - Failed
  depends_on "jemalloc" unless OS.mac?
  depends_on "readline" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    Language::Python.rewrite_python_shebang(Formula["python@3.8"].opt_bin/"python3")

    mkdir "src/build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "TEST PASSED CORRECTLY", shell_output("#{bin}/spades.py --test")
  end
end
