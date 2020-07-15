class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.3.tar.gz"
  sha256 "48f005949ada1ace8ad8c00bb27fad17d566e5bcdbec8be6078e44f8ad04759a"
  license "GPL-2.0"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git"

  bottle do
    cellar :any
    sha256 "41c1d0c89b5e055b780b7530fc22aefa7cde6c45601f8b2f6cae636d5651bbf2" => :catalina
    sha256 "3a0c9b8c27380b0863e22bc6859753018efb27619790d63681b4ebaccc39fb75" => :mojave
    sha256 "12b85ee9411d6611508f8797db8092c29dc67cc621edf6dc74ddde0d0b18a126" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on :macos => :high_sierra # needs futimens

  # Remove with upstream release > 0.83.3
  # https://github.com/joncampbell123/dosbox-x/pull/1715
  patch do
    url "https://github.com/joncampbell123/dosbox-x/commit/a8be3fcda5f91d8cff9f792b366cc05ad75eaef0.patch?full_index=1"
    sha256 "39c96ae37b58a1410b0dc9cdc8b9c9bb8c55792395b2b049bebf3cb4c8838d20"
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    system "./build-macosx", *args
    system "make", "install"
  end

  test do
    assert_match /DOSBox-X version #{version}/, shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
