class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-265.tar.bz2"
  sha256 "5dac8fa64350efe5abd3e9f618db2fcfeee1718db329cfd27b29bd61f113605d"
  license "BSD-2-Clause"

  livecheck do
    url "http://www.kylheku.com/cgit/txr"
    regex(/href=.*?txr[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e6843e2622acd9d3d5b0572d653c8e1815e94334d9ccf252fd2e37a6eef35027"
    sha256 cellar: :any, big_sur:       "923d2986a6abfdd835b64d33e81ba524bb7f10e159d4d06ef16b6d41d081c09e"
    sha256 cellar: :any, catalina:      "48150bfeeeb08f84c4832c9b5f4bd2092d46a2cf0ef42c08b9777783f2dba074"
    sha256 cellar: :any, mojave:        "fa4cccbcd32ceeaa321f6ea489d8f3273cdb92f5457244f634b293abe4bb2b31"
  end

  depends_on "libffi"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--inline=static inline"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
