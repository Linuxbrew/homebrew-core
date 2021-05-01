class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/v0.5.0.tar.gz"
  sha256 "441be80edcaed80c2372e9053401ff8faedb96bd1af9d11d8fedac98e56ccea8"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "67fbe0746e879838e5a9ad6999bec6f45889a650b29b2d97e3766630d6de2103"
    sha256 cellar: :any,                 big_sur:       "b202aecfdd3276b36c0dfff5434074753b19a298db6de61a0d6efefa341975fd"
    sha256 cellar: :any,                 catalina:      "94c1c67c1589868066218924f006f457436504cf49ebaaac36947d333b34cc3f"
    sha256 cellar: :any,                 mojave:        "0799a1f702a1333d592c97c093ba1096ce22766a60aca9870c5c6294e023b9a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a2cf1476286fb4f867a310ef648ed5155de79de199512d41ec11d12dab5a04"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "make", "install", "PREFIX=#{prefix}", "mandir=#{man}"
  end

  test do
    # https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
        db 0
        assert @
    EOS
    system "#{bin}/rgbasm", "source.asm"
  end
end
