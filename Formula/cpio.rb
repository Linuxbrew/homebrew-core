class Cpio < Formula
  desc "Copies files into or out of a cpio or tar archive"
  homepage "https://www.gnu.org/software/cpio/"
  url "https://ftp.gnu.org/gnu/cpio/cpio-2.12.tar.bz2"
  mirror "https://ftpmirror.gnu.org/cpio/cpio-2.12.tar.bz2"
  sha256 "70998c5816ace8407c8b101c9ba1ffd3ebbecba1f5031046893307580ec1296e"
  # tag "linuxbrew"

  bottle do
    sha256 "2e8018465c5abc4e3a825653530ae4dd8f1c06219bf6aceac4e8a74fd4e69cbe" => :x86_64_linux # glibc 2.19
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cpio", "--version"
  end
end
