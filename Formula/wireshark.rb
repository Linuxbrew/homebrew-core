class Wireshark < Formula
  desc "Graphical network analyzer and capture tool"
  homepage "https://www.wireshark.org"
  url "https://www.wireshark.org/download/src/all-versions/wireshark-3.2.5.tar.xz"
  mirror "https://1.eu.dl.wireshark.org/src/all-versions/wireshark-3.2.5.tar.xz"
  sha256 "bd89052a5766cce08b1090df49628567e48cdd24bbaa47667c851bac6aaac940"
  head "https://code.wireshark.org/review/wireshark", :using => :git

  bottle do
    sha256 "27ac1313478b321ece59273e73ff0ef3dbfc8f3bb5e804f84d1647e9c3493f02" => :catalina
    sha256 "6f7222fa6ba170a6f51cdde7b4167aa25fff8bd5f507b0741844f30225e0c959" => :mojave
    sha256 "2201d32c491a0b8e0d1116e58120695826fb4b1782129ec62bcb8d67b222c6f5" => :high_sierra
    sha256 "58d034c110f4d8b569ece80834c03739bc85010a0d573e466f90b02b3c18957d" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libmaxminddb"
  depends_on "libsmi"
  depends_on "libssh"
  depends_on "lua@5.1"
  depends_on "nghttp2"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    args = std_cmake_args + %W[
      -DENABLE_CARES=ON
      -DENABLE_GNUTLS=ON
      -DENABLE_MAXMINDDB=ON
      -DBUILD_wireshark_gtk=OFF
      -DENABLE_PORTAUDIO=OFF
      -DENABLE_LUA=ON
      -DLUA_INCLUDE_DIR=#{Formula["lua@5.1"].opt_include}/lua-5.1
      -DLUA_LIBRARY=#{Formula["lua@5.1"].opt_lib}/liblua5.1.dylib
      -DCARES_INCLUDE_DIR=#{Formula["c-ares"].opt_include}
      -DGCRYPT_INCLUDE_DIR=#{Formula["libgcrypt"].opt_include}
      -DGNUTLS_INCLUDE_DIR=#{Formula["gnutls"].opt_include}
      -DMAXMINDDB_INCLUDE_DIR=#{Formula["libmaxminddb"].opt_include}
      -DENABLE_SMI=ON
      -DBUILD_sshdump=ON
      -DBUILD_ciscodump=ON
      -DENABLE_NGHTTP2=ON
      -DBUILD_wireshark=OFF
      -DENABLE_APPLICATION_BUNDLE=OFF
      -DENABLE_QT5=OFF
    ]

    system "cmake", *args, "."
    system "make", "install"

    # Install headers
    (include/"wireshark").install Dir["*.h"]
    (include/"wireshark/epan").install Dir["epan/*.h"]
    (include/"wireshark/epan/crypt").install Dir["epan/crypt/*.h"]
    (include/"wireshark/epan/dfilter").install Dir["epan/dfilter/*.h"]
    (include/"wireshark/epan/dissectors").install Dir["epan/dissectors/*.h"]
    (include/"wireshark/epan/ftypes").install Dir["epan/ftypes/*.h"]
    (include/"wireshark/epan/wmem").install Dir["epan/wmem/*.h"]
    (include/"wireshark/wiretap").install Dir["wiretap/*.h"]
    (include/"wireshark/wsutil").install Dir["wsutil/*.h"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Wireshark.app with Homebrew Cask:
        brew cask install wireshark

      If your list of available capture interfaces is empty
      (default macOS behavior), install ChmodBPF:
        brew cask install wireshark-chmodbpf
    EOS
  end

  test do
    system bin/"randpkt", "-b", "100", "-c", "2", "capture.pcap"
    output = shell_output("#{bin}/capinfos -Tmc capture.pcap")
    assert_equal "File name,Number of packets\ncapture.pcap,2\n", output
  end
end
