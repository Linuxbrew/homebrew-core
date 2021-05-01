class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.4.tar.bz2"
  sha256 "0f5157030162844b398e7ce69b8bb967c2edb8064b0a9c9bb5517eb621459fbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f8a7c3b5c61c48affa144576747aa93a18c49f8b861b782e45aeb643a2708363"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
