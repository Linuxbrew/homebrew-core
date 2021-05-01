class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.14.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.14.1.tar.gz"
  sha256 "4a3205c570c30756f1a8b1ad0f1a63d078a92f0fac8e543471d54f4552da18c2"
  license "AGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "42fb8e4b25df8f32e358d4f422f91b6673c78bac23a6dcac719cbac480e21d56"
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
  uses_from_macos "sqlite"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
