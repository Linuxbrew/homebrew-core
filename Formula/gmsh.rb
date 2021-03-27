class Gmsh < Formula
  desc "3D finite element grid generator with CAD engine"
  homepage "https://gmsh.info/"
  url "https://gmsh.info/src/gmsh-4.8.1-source.tgz"
  sha256 "d5038f5f25ae85973536fb05cc886feb1bd7d67e2605a9d8789bcc2528fa8b35"
  license "GPL-2.0-or-later"
  head "https://gitlab.onelab.info/gmsh/gmsh.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c6b9e4bf4674060c57665d5ef9aac06a1e03df462aa191003c2c8035210d927c"
    sha256 cellar: :any, big_sur:       "0d54d3321b9232d064a508726c01fbec6ac6a2a007913ee68525345245a22264"
    sha256 cellar: :any, catalina:      "c5e547b974a76682f0f0f4cf1f6bd337f61aa21e83d8f7e25d44b4b1fec252be"
    sha256 cellar: :any, mojave:        "d1cdc112e555b030189d27992a52336b09013ce0b30d90225c34856c157bb08d"
  end

  depends_on "cmake" => :build
  depends_on "cairo"
  depends_on "fltk"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "opencascade"

  def install
    args = std_cmake_args + %W[
      -DENABLE_OS_SPECIFIC_INSTALL=0
      -DGMSH_BIN=#{bin}
      -DGMSH_LIB=#{lib}
      -DGMSH_DOC=#{pkgshare}/gmsh
      -DGMSH_MAN=#{man}
      -DENABLE_BUILD_LIB=ON
      -DENABLE_BUILD_SHARED=ON
      -DENABLE_NATIVE_FILE_CHOOSER=ON
      -DENABLE_PETSC=OFF
      -DENABLE_SLEPC=OFF
      -DENABLE_OCC=ON
    ]

    ENV["CASROOT"] = Formula["opencascade"].opt_prefix

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"

      # Move onelab.py into libexec instead of bin
      mkdir_p libexec
      mv bin/"onelab.py", libexec
    end
  end

  test do
    system "#{bin}/gmsh", "#{share}/doc/gmsh/tutorial/t1.geo", "-parse_and_exit"
  end
end
