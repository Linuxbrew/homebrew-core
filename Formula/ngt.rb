class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.11.4.tar.gz"
  sha256 "3b54ab93ecb8345184dee9d94e3aa5ecc005f934d25ac724a709314ff643467b"

  bottle do
    cellar :any
    sha256 "2c94d14ba60de315fbe650f5088d61e454806c1087a16bfd4d2bd58559e5740e" => :catalina
    sha256 "f3bd23b56cadb1e917b7820b67039974517df2931614002d45978d866ce611d2" => :mojave
    sha256 "d605324f52583c5d8ded4383a00302d1e602d5f2b54d498eac7ea4cd862db399" => :high_sierra
    sha256 "e2108fefad111cfff0e22da23cc5236cbbbb711bcea0865479a169d29968d96a" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
