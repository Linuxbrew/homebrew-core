class Harfbuzz < Formula
  desc "OpenType text shaping engine"
  homepage "https://github.com/harfbuzz/harfbuzz"
  url "https://github.com/harfbuzz/harfbuzz/archive/2.8.2.tar.gz"
  sha256 "4164f68103e7b52757a732227cfa2a16cfa9984da513843bb4eb7669adc6f220"
  license "MIT"
  head "https://github.com/harfbuzz/harfbuzz.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "30891c4b5ab922c7d1c8b9bc19a8d4cd8a3c917eb480c67437b507097ea715e2"
    sha256 cellar: :any, big_sur:       "c7b09192eba72dcbf12c88806cf867598463529e12aab72b25197b7c1cf264e1"
    sha256 cellar: :any, catalina:      "770f015a98bf6341eb0b49b16be103219b12065c33f7701d68fe097f817f838c"
    sha256 cellar: :any, mojave:        "ec242538c3011c16ed51e24b59f64275b5cffbe0251cc0893cae9e7521bcfadf"
    sha256               x86_64_linux:  "841b4d0f191c8d71ddf8dce145d268146edab633885d1b61b55271e23c903db0" # linuxbrew-core
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphite2"
  depends_on "icu4c"

  resource "ttf" do
    url "https://github.com/harfbuzz/harfbuzz/raw/fc0daafab0336b847ac14682e581a8838f36a0bf/test/shaping/fonts/sha1sum/270b89df543a7e48e206a2d830c0e10e5265c630.ttf"
    sha256 "9535d35dab9e002963eef56757c46881f6b3d3b27db24eefcc80929781856c77"
  end

  def install
    args = %w[
      --default-library=both
      -Dcairo=enabled
      -Dcoretext=enabled
      -Dfreetype=enabled
      -Dglib=enabled
      -Dgobject=enabled
      -Dgraphite=enabled
      -Dicu=enabled
      -Dintrospection=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    resource("ttf").stage do
      shape = `echo 'സ്റ്റ്' | #{bin}/hb-shape 270b89df543a7e48e206a2d830c0e10e5265c630.ttf`.chomp
      assert_equal "[glyph201=0+1183|U0D4D=0+0]", shape
    end
  end
end
