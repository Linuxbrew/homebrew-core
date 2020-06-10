class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.7.0.tar.xz"
  sha256 "d26b2952426d2518f3db5cdeda4fe3cd668fc5bb38a598781e4d1d3f7f8ca7be"

  bottle do
    sha256 "d117bca0832ea1c01d4b5e4797dc48aa6daf8d3424fc22296106fb513b65c338" => :catalina
    sha256 "2640af399ccf6a431800ba2d893b9ca776df371f252df931c785e4ef33b66940" => :mojave
    sha256 "b03e30204741a9638a81c1cff253f97f3b4eb19a49a0f9dfeb542d32cfca60b7" => :high_sierra
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
