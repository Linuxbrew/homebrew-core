class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-atk/2.34/at-spi2-atk-2.34.1.tar.xz"
  sha256 "776df930748fde71c128be6c366a987b98b6ee66d508ed9c8db2355bf4b9cc16"
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "at-spi2-core"
  depends_on "atk"
  depends_on "libxml2"

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
