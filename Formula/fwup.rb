class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.7.0/fwup-1.7.0.tar.gz"
  sha256 "e2cc5724a7edf2a0287102ad5c2f018a846d849060f30b5024f193086ba61a19"

  bottle do
    cellar :any
    sha256 "eaa8838413b1710cf7abdb1cf84aaf5f3813b09620efac1d4b552b8c5f94a3e8" => :catalina
    sha256 "9f47c5153e760eff6a309d1a9ec372adeda8626487d3d41c6360360e0596b5ce" => :mojave
    sha256 "d6f0110302365b2db4dbc3bcf3b66c6435ed5d48f619c2c9beec7d4a74941979" => :high_sierra
    sha256 "b1e23b3e22ac7894c29c042d7646b9ae6aabd2986608fa63de827f4b4d84f8c1" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
