class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://www.mpg123.de/"
  url "https://downloads.sourceforge.net/project/mpg123/mpg123/1.25.6/mpg123-1.25.6.tar.bz2"
  mirror "https://www.mpg123.de/download/mpg123-1.25.6.tar.bz2"
  sha256 "0f0458c9b87799bc2c9bf9455279cc4d305e245db43b51a39ef27afe025c5a8e"

  bottle do
    sha256 "a6f996f5ce5bccf8fba568fe10489e4574d81599e90c6cdae036a373a453fdd2" => :sierra
    sha256 "1a6e13ae5c41967f3888100c206c88f255163b20aec5bf3c8f43db23a70d5e96" => :el_capitan
    sha256 "0077d48101b213dd32503b0edc84efb730d5d00f6c3ca9ee77b4d4c133c16b4e" => :yosemite
    sha256 "d258475abb7dcfcf1ce402c117d7f2b22c63ecfea48cf592126e0fa7ea8642b1" => :x86_64_linux # glibc 2.19
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-module-suffix=.so
    ]
    args << "--with-default-audio=coreaudio" if OS.mac?

    if MacOS.prefer_64_bit?
      args << "--with-cpu=x86-64"
    else
      args << "--with-cpu=sse_alone"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"mpg123", "--test", test_fixtures("test.mp3")
  end
end
