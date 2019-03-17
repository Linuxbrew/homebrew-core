# at-spi2-core: Build a bottle for Linuxbrew
class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.30/at-spi2-core-2.30.1.tar.xz"
  sha256 "856f1f8f1bf0482a1bc275b18b9f28815d346bc4175004d37e175a1a0e50ca48"
  revision 1
  # tag "linuxbrew"

  bottle do
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson-internal" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "dbus"
  depends_on "gettext"
  depends_on "glib"
  depends_on "linuxbrew/xorg/xorgproto"
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/libxtst"

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
