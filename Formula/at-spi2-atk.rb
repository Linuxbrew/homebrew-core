class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://www.freedesktop.org/wiki/Accessibility/AT-SPI2"
  url "https://download.gnome.org/sources/at-spi2-atk/2.34/at-spi2-atk-2.34.2.tar.xz"
  sha256 "901323cee0eef05c01ec4dee06c701aeeca81a314a7d60216fa363005e27f4f0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dfd83f6ff7daa444a32de826f09c86d976e84958aa93c8e615ecbcff41e30207"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "at-spi2-core"
  depends_on "atk"
  depends_on "libxml2"
  depends_on :linux

  def install
    ENV.refurbish_args

    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "--libdir=#{lib}", ".."
      system "ninja"
      system "ninja", "install"
    end
  end
end
