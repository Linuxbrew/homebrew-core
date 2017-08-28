class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.1.tar.gz"
  sha256 "c928a37072e12f9d7df1fe34e6523a9e3495f0ac7fce5835c9144821b74867ee"

  bottle do
    cellar :any
    sha256 "36cccedf9f95684102b4639a2c208822c93d6a5fcb7fc4118af904a4afffe79f" => :sierra
    sha256 "cf0c9d21954f4ad0648d769159d92131b4c42803e02b5b382f1a1ea0c487cf0d" => :el_capitan
    sha256 "8796fbc088e1745e36129c63d7005a4f95029d2ca89fc442a7c42cff3659b0f1" => :yosemite
    sha256 "90e9110b36f21c9eea0ac0ac4fe25425923064793b2aed8c3ad7f3ebadbc4e75" => :x86_64_linux # glibc 2.19
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
