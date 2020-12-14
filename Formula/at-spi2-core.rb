class AtSpi2Core < Formula
  desc "Protocol definitions and daemon for D-Bus at-spi"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-core/2.36/at-spi2-core-2.36.1.tar.xz"
  sha256 "97417b909dbbf000e7b21062a13b2f1fd52a336f5a53925bb26d27b65ace6c54"
  revision 3

  bottle do
    cellar :any
    sha256 "5d336bd939f678b48dc1ced97ed0def383999638d80caa8cb2da780594556524" => :big_sur
    sha256 "ce746662b98d93511b86920011b5cafcd2eecbce4c9c40d8c52a143cdf708456" => :catalina
    sha256 "1d0c8e266acddcebeef3d9f6162d6f7fa0b193f5f71837174fb2ef0b39d324f3" => :mojave
  end

  depends_on "gobject-introspection" => :build
  depends_on "intltool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
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
