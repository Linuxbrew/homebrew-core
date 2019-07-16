class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-core/2.32/at-spi2-core-2.32.0.tar.xz"
  sha256 "43a435d213f8d4b55e8ac83a46ae976948dc511bb4a515b69637cb36cf0e7220"
  revision 2
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
