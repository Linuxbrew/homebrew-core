class SimpleScan < Formula
  desc "GNOME document scanning application"
  homepage "https://gitlab.gnome.org/GNOME/simple-scan"
  url "https://download.gnome.org/sources/simple-scan/3.38/simple-scan-3.38.0.tar.xz"
  sha256 "4356affd035f01a57b182199effd9808700efccb498bdc8367bf09bce404c311"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "1fef462043b0581c3c8f87d9fbbd36942447cb7d91a99134f62b446e08945d79" => :catalina
    sha256 "af8f8b195ba4b8bcdd23ef18cfff5bc6b75ff60b02b0a6c16ad8186193e19018" => :mojave
    sha256 "f883982bc960fc7713445421f8ed2406f7b88a41082a918e606b96de1c571069" => :high_sierra
  end

  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libgusb"
  depends_on "sane-backends"
  depends_on "webp"

  def install
    ENV["DESTDIR"] = "/"
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    system "#{bin}/simple-scan", "-v"
  end
end
