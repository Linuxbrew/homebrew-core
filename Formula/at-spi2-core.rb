class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.36/at-spi2-core-2.36.1.tar.xz"
  sha256 "97417b909dbbf000e7b21062a13b2f1fd52a336f5a53925bb26d27b65ace6c54"
  revision 3

  bottle do
    sha256 x86_64_linux: "b009112ec310ace56168d85c52bb4891af0dd05c50cbec1c24a9e9ea41feb7de"
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on "libx11"
  depends_on "libxtst"
  depends_on :linux
  depends_on "xorgproto"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    system "#{libexec}/at-spi2-registryd", "-h"
  end
end
