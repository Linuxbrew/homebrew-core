# flann: Build a bottle for Linux
class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://www.cs.ubc.ca/research/flann/"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  revision 8

  bottle do
    cellar :any
    sha256 "3292091ca87b96e55066037d23a36b3a1e4a7da976692376c7ed8aa1e38db71e" => :catalina
    sha256 "4d1b3d6e306e54bb160f1698a36d9b85d1d01b411651284ea00717b2e91c0089" => :mojave
    sha256 "8c91ce1046b4f961f5c6b4c2fcb3602ab8f889d7a3a1c3806f8aeaa52d4b7ac0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  # Fix for Linux build: https://bugs.gentoo.org/652594
  # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
  unless OS.mac?
    patch do
      url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
      sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
    end
  end

  resource("dataset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.dat"
    sha256 "dcbf0268a7ff9acd7c3972623e9da722a8788f5e474ae478b888c255ff73d981"
  end

  resource("testset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/testset.dat"
    sha256 "d9ff91195bf2ad8ced78842fa138b3cd4e226d714edbb4cb776369af04dda81b"
  end

  resource("dataset.hdf5") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.hdf5"
    sha256 "64ae599f3182a44806f611fdb3c77f837705fcaef96321fb613190a6eabb4860"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset.dat").stage testpath
    resource("testset.dat").stage testpath
    resource("dataset.hdf5").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
