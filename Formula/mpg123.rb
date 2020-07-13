class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.26.2/mpg123-1.26.2.tar.bz2"
  sha256 "00f7bf7ea64fcec2c9d07751d6ad8849343ee09c282ea3b0d5dd486e886e2ff3"

  bottle do
    sha256 "29e4e2b5e306f94d2ce0e900f8413b4751f5df28488a476558527119b09bf015" => :catalina
    sha256 "9e80680b18a8b2e000d32aee02c5b5b03e95d617119d1a922a1ac48da4df66f6" => :mojave
    sha256 "6a9d7414515325f52473be05e484faa1c314ffb65582588d9c312400d3e9d6bd" => :high_sierra
    sha256 "a8eb277e23ef13085964964b28ef59da105b29268a224ab220696bc1cb1da530" => :x86_64_linux
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
      --with-cpu=x86-64
    ]
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
