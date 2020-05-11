class Adios2 < Formula
  desc "Next generation of ADIOS developed in the Exascale Computing Program"
  homepage "https://adios2.readthedocs.io"
  url "https://github.com/ornladios/ADIOS2/archive/v2.5.0.tar.gz"
  sha256 "7c8ff3bf5441dd662806df9650c56a669359cb0185ea232ecb3578de7b065329"
  revision 2
  head "https://github.com/ornladios/ADIOS2.git", :branch => "master"

  bottle do
    sha256 "c317685a1b0aea372bf5c0ca50eb632ebe804fea5a4fbdc8a11ba8921c3853de" => :catalina
    sha256 "98cbaa27c5fe28190836b0c7b8e8a521e36ae5c6c1f142f9f8167afd86e15122" => :mojave
    sha256 "efd2cb19cdfe79c5306e4d15c5f553f6319b92c6f2183488b163801f31f158b7" => :high_sierra
    sha256 "d61eb21c60cae2171ddf920251477ff54c24f04a6bdc289c6f39cc85bd937d4f" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "c-blosc"
  depends_on "libfabric"
  depends_on "libpng"
  depends_on "mpi4py"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "python@3.8"
  depends_on "zeromq"

  uses_from_macos "bzip2"

  # HighSierra build issue with JSON support, fix already in post-2.5.0 master
  # reference: https://github.com/ornladios/ADIOS2/pull/1805
  patch do
    url "https://github.com/ornladios/ADIOS2/pull/1805.patch?full_index=1"
    sha256 "6760801cfddc48c6df158295e58d007c8b07abb82a1e79ee89c5a1e3e955d2c1"
  end

  def install
    # fix `include/adios2/common/ADIOSConfig.h` file audit failure
    inreplace "source/adios2/common/ADIOSConfig.h.in" do |s|
      s.gsub! ": @CMAKE_C_COMPILER@", ": /usr/bin/clang"
      s.gsub! ": @CMAKE_CXX_COMPILER@", ": /usr/bin/clang++"
    end

    args = std_cmake_args + %W[
      -DADIOS2_USE_Blosc=ON
      -DADIOS2_USE_BZip2=ON
      -DADIOS2_USE_DataSpaces=OFF
      -DADIOS2_USE_Fortran=ON
      -DADIOS2_USE_HDF5=OFF
      -DADIOS2_USE_MGARD=OFF
      -DADIOS2_USE_MPI=ON
      -DADIOS2_USE_PNG=ON
      -DADIOS2_USE_Python=ON
      -DADIOS2_USE_SZ=OFF
      -DADIOS2_USE_ZeroMQ=ON
      -DADIOS2_USE_ZFP=OFF
      -DCMAKE_DISABLE_FIND_PACKAGE_BISON=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_CrayDRC=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_FLEX=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_LibFFI=TRUE
      -DCMAKE_DISABLE_FIND_PACKAGE_NVSTREAM=TRUE
      -DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3
      -DADIOS2_BUILD_TESTING=OFF
      -DADIOS2_BUILD_EXAMPLES=OFF
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      rm_rf Dir[prefix/"bin/bp4dbg"] # https://github.com/ornladios/ADIOS2/pull/1846
    end

    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.cpp"
    (pkgshare/"test").install "examples/hello/bpWriter/helloBPWriter.py"
  end

  test do
    adios2_config_flags = `adios2-config --cxx`.chomp.split
    system "mpic++",
           (pkgshare/"test/helloBPWriter.cpp"),
           *adios2_config_flags
    system "./a.out"
    assert_predicate testpath/"myVector_cpp.bp", :exist?

    system Formula["python@3.8"].opt_bin/"python3", "-c", "import adios2"
    system Formula["python@3.8"].opt_bin/"python3", (pkgshare/"test/helloBPWriter.py")
    assert_predicate testpath/"npArray.bp", :exist?
  end
end
