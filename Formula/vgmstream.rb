class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://hcs64.com/vgmstream.html"
  url "https://github.com/losnoco/vgmstream/archive/r1050-2908-g14dc8566.tar.gz"
  version "r1050-2908-g14dc8566"
  sha256 "8d03ef4b3ff4c397c1a7b0a4132eb0813d50901c78436b09558cb2489ea6d904"
  head "https://github.com/kode54/vgmstream.git"

  bottle do
    cellar :any
    sha256 "27cb2df8b0a88d31507695a9b8711bbeca66ac9a09f8e34de399a45b7f2c216a" => :catalina
    sha256 "8a52d5fdc81f87c709c0f41c90b02cba2788f7429402a327fcf343d331346018" => :mojave
    sha256 "513761e04c72ecf6300222bd06d662b7ab0ae74b56f37cc586dcd514e5f2ffc3" => :high_sierra
    sha256 "bffced1c31aaeec4559d60dbc3239ccd16a3fb0cbab15de072628db5ac6555b9" => :x86_64_linux
  end

  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "make", "vgmstream_cli"
    system "make", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
