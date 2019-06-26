class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.2.0.tar.gz"
  sha256 "485556bd27bd546c025d9f9a2f53e89b4460bf820fd5de847ede2539f7440091"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "c6efeb76438b2951e0dc8225e97a87a699662da1b6f0965957cd850e90dc8421" => :mojave
    sha256 "e444d5b2fcc34189562fd4e01f2bcd20707acbd5588753f35a93dd1e0892b3ae" => :high_sierra
    sha256 "af4c5fd9f026676f7e89cf1ef94af01f685347cc1e928b72c681b84849156c0d" => :sierra
    sha256 "c5653cba798a22db991df4e068ca1ad26c4808bd703adcceab45bcb929e2e0d3" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"
  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
