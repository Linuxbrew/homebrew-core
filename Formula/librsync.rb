class Librsync < Formula
  desc "Library that implements the rsync remote-delta algorithm"
  homepage "https://librsync.github.io/"
  url "https://github.com/librsync/librsync/archive/v2.3.1.tar.gz"
  sha256 "dbd7eb643665691bdf4009174461463737b19b4814b789baad62914cabfe4569"
  license "LGPL-2.1"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb1526a88a99556f1ae98c7fa008a8c17ddbe2efe2e55de0192ccbccf9840937" => :catalina
    sha256 "27f16505bf1b37a9701d70701e708451d47743a3b4d453dcc1d4048065af05af" => :mojave
    sha256 "20fd33975022b7caaa12b9906b726f1b9dd9a792d9291170e72298a351650610" => :high_sierra
    sha256 "73eb18e6db5100a584ea4463e4f6efd1da2f6e2b4fcea3b251f4c3d20bf17455" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "popt"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    man1.install "doc/rdiff.1"
    man3.install "doc/librsync.3"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdiff -V")
  end
end
