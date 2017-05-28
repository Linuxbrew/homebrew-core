
class Mpg123 < Formula
  desc "MP3 player for Linux and UNIX"
  homepage "https://sourceforge.net/projects/mpg123/"
  url "https://master.dl.sourceforge.net/project/mpg123/mpg123/1.24.0/mpg123-1.24.0.tar.bz2"
  mirror "https://netix.dl.sourceforge.net/project/mpg123/mpg123/1.24.0/mpg123-1.24.0.tar.bz2"
  sha256 "55fb169a7711938f5df0497d1ffe28419fbef50011dc01d00b216379e6a2256c"
  
  bottle do
    cellar :any
    sha256 "f2781679463e9da849fe9fd73f57383b5d53380c1b71b600a9595b99ad28f3f1" => :sierra
    sha256 "82b93955b350286f89f40bce0155495a5583b80ddf2fd87a90eddb673de82b94" => :el_capitan
    sha256 "8d6d266e0963a9f93d28e653da6b60fe9663af9dd49560d36f7b14731a158a65" => :yosemite
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
    system bin/"mpg123", test_fixtures("test.mp3")
  end
end
