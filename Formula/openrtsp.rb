class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.07.09.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.07.09.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "bc982f5fb2142f084e619d9ab342194e01024dce3aae817ca84c73aea4e0e23e"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "1c40add9d23211a486b2b88a31e4bba982bd564abfeeccad9c92f6cf07af1f64" => :catalina
    sha256 "d3cb3da0a6f5460ebf74b6dd449a637d6ca36315e5fdd5066f85e37f0dfd13fd" => :mojave
    sha256 "94b3edec399edc25cc8e2c763e10d54bb16cda4d7761bde461591ebb810cb207" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
