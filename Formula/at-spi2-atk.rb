class AtSpi2Atk < Formula
  desc "Accessibility Toolkit GTK+ module"
  homepage "https://wiki.linuxfoundation.org/accessibility/"
  url "https://download.gnome.org/sources/at-spi2-atk/2.32/at-spi2-atk-2.32.0.tar.xz"
  sha256 "0b51e6d339fa2bcca3a3e3159ccea574c67b107f1ac8b00047fa60e34ce7a45c"
  revision 1
  # tag "linux"

  bottle do
    cellar :any_skip_relocation
    sha256 "22cb9bd10ea2f22df706bd718b36aeeb1e0f7d0e669616ea35c5ab415c1e8580" => :x86_64_linux
  end

  depends_on "meson-internal" => :build
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
