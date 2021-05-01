class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://github.com/pupnp/pupnp/releases/download/release-1.14.6/libupnp-1.14.6.tar.bz2"
  sha256 "3168f676352e2a6e45afd6ea063721ed674c99f555394903fbd23f7f54f0a503"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0b2ea47defd1e5c95aa962205741158fa8a57dc07e9148bc547f394b84ecf02a"
    sha256 cellar: :any,                 big_sur:       "31da1e0e95056781f80af7179b22082fc8a9a3a343944ef6030517ba706a6dd0"
    sha256 cellar: :any,                 catalina:      "635bb6431799dc93fc755eea42f91f69d455741786a71aa932bdf066ede54fa9"
    sha256 cellar: :any,                 mojave:        "9a488673951bb9bd81b1112d5c451c329dc1479e12d3d1d7fee3d780d3648364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40e47bca94c12332a3cec0d68d355afcdb948970afd65ad8669a6dea9dac3ca8"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
