class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.13.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.13.0.tar.gz"
  sha256 "a3f78af7f85402cccadc21cfdd5febf8d64a5d5b699645644fff7b2233ba5f3c"
  license "AGPL-3.0"

  bottle do
    cellar :any
    sha256 "bcef73933e829bc7fd6a52928f33087dd1261ab879735e58d99801305ef3649f" => :catalina
    sha256 "6c0fa2f4d6c274b3273e6c2f8f290d28c0bec457b887041b4d9f1defc3d5abae" => :mojave
    sha256 "bb24f051b036b4729d52937c6b31b790ffff064f327a34ccaf563279ec809db9" => :high_sierra
    sha256 "e636911b758e58c84e74b8eb23fdc51dc87167e0f47778e85e61fc8c3bbde314" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libsodium"
  depends_on "libunistring"
  depends_on "unbound"

  uses_from_macos "curl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
