class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.2.tar.xz"
  sha256 "7213b665dc1296ede6ae06f35e44c146efbdb42e09bb9558ce1ed8877d41ff4e"

  bottle do
    sha256 "2acdf43a976beae67dd1a1c8c17da3ea33e3097e091911edf58236afe811d599" => :catalina
    sha256 "736d1a207d3f30d27b7b52c11ab6bb2bc41ac24d45a2ff9d603070e336e1689d" => :mojave
    sha256 "8d62e6ba9e16d6eccc1ee41b979571a593cfb0074944d92fecf24411ac7e3545" => :high_sierra
    sha256 "79be50844dbbca04b116b2a69b3f9c1b0198664df7e86bb2fb6c555ad28780b0" => :x86_64_linux
  end

  depends_on "cmake" => :build
  unless OS.mac?
    depends_on "openssl@1.1"
    depends_on "xz" # For LZMA
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  conflicts_with "libtcod", "minizip2",
    :because => "libtcod, libzip and minizip2 install a `zip.h` header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    share.install prefix/"man" if OS.mac?
  end

  test do
    zip = OS.mac? ? "/usr/bin/zip" : which("zip")
    if zip.nil?
      opoo "Not testing unzip, because it requires zip, which is unavailable."
      return
    end

    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match /\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1)
  end
end
