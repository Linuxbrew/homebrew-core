class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      :tag      => "v3.1.3",
      :revision => "4f695cae3ba720981ab7e38c16d4ab1adf4f01f5"
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 "2bf9011ff6d224e82e972ca29fe6d37ad3bead47ceb495168592ee77e0a7bfdf" => :catalina
    sha256 "37722b4b8cb194ca93affe448ca9330ae8978640374e47a8e11e5efdb5fcba97" => :mojave
    sha256 "e7060d439cd05a646afae4d6fd538f991c0d656ccc5acb4f49f52fb3b3f57478" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on :macos # Due to Python 2 (https://github.com/zeek/zeek/issues/706)
  depends_on "openssl@1.1"

  uses_from_macos "flex"
  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DDISABLE_PYTHON_BINDINGS=on",
                      "-DBROKER_DISABLE_TESTS=on",
                      "-DBUILD_SHARED_LIBS=on",
                      "-DINSTALL_AUX_TOOLS=on",
                      "-DINSTALL_ZEEKCTL=on",
                      "-DCAF_ROOT_DIR=#{Formula["caf"].opt_prefix}",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                      "-DZEEK_LOCAL_STATE_DIR=#{var}"
      system "make", "install"
    end
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP Parsing", shell_output("#{bin}/zeek --print-plugins")
  end
end
