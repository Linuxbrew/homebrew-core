# xrootd: Build a bottle for Linuxbrew
class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.1/xrootd-4.8.1.tar.gz"
  sha256 "edee2673d941daf7a6e5c963d339d4a69b4db5c4b6f77b4548b3129b42198029"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "17fd0df59c94f95e6c849c62155527a1cc61b14c1324c35e424175bd7847c49d" => :high_sierra
    sha256 "a9cf8e475ec61737b216d287354d9f953f66e6ed2e0ef2af71476bb37374b306" => :sierra
    sha256 "76ce93c37b9d8543816c985b32c8c9a9d519815891e42f909d040a35c70f9fb4" => :el_capitan
    sha256 "784d0d03fe7f848dff06d7c3f6c4a932bb6b79c3bddecfc181b8b9c38105dc6c" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
