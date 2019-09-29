class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  url "https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.43.tar.bz2"
  sha256 "91e762520003013834ac1adb4a938d53b22a216341c061b0cf05603b290faf6b"

  bottle do
    cellar :any
    sha256 "3517eab75bf5bdb7798414d0af2aaaaf43edd248abc960b008d89b0a0958d537" => :catalina
    sha256 "08e7414a7641d1e184c936537ff67f72f52649374d2308b896d4146ccc2c08fe" => :mojave
    sha256 "0389911a93a88efd4a69b52dea8ecb872fdb55bcfff45d2f7313be5f79730861" => :high_sierra
    sha256 "02966e199e627803e700bc1905bf30a07f87f82bdd627cc7e915966af727fd21" => :sierra
    sha256 "c5f2a6176065d9e76544240357026c6da7fcf661f7f6b0ff30e33242a4c778cf" => :x86_64_linux
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-check", "Skip build-time tests (not recommended)"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-pcre8
      --enable-pcre16
      --enable-pcre32
      --enable-unicode-properties
      --enable-pcregrep-libz
      --enable-pcregrep-libbz2
    ]
    args << "--enable-jit" if MacOS.version >= :sierra

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "test" if build.with? "check"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
