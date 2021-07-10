class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.13.0/libfabric-1.13.0.tar.bz2"
  sha256 "0c68264ae18de5c31857724c754023351614330bd61a50b40cef2b5e8f63ab28"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d70fb55fb5fa73564492482956b460b163c7170ee8063502315d919e774c9d36"
    sha256 cellar: :any,                 big_sur:       "c3aa52601f5c00b8c7590349e6c55ac49a9f0d0bd11413d264b5c7d0089fbc30"
    sha256 cellar: :any,                 catalina:      "bc75cab6edaf0b5288dbb30fc3bbcc403231fb0cf7edbe06e2fb24b7ccae4633"
    sha256 cellar: :any,                 mojave:        "906289db2df6c86e5016f15534aced96c67392e1a1e3f72b606882077684d402"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "691e2168f24f4a1b8d06d1964379e6bf897c81f0613f6c269551a4fed9b59f1e" # linuxbrew-core
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
