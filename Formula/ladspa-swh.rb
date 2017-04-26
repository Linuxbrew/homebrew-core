class LadspaSwh < Formula
  desc "The SWH Plugins package for the LADSPA plugin system"
  homepage "http://plugin.org.uk"
  url "https://github.com/swh/ladspa/archive/v0.4.16.tar.gz"
  sha256 "8accd2fcc932c9d35822d42e579308f7c19096af537729dc804b7bdc92de8c6b"

  option "with-sse", "Uses SSE instructions" => :recommended
  option "with-rpath", "Hardcode runtime library paths" => :optional

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "XML::Parser" => :perl
  depends_on "gcc" => :build if build.with? "sse"

  def install
    ENV.append_to_cflags "-fPIC" unless OS.mac?

    system "autoreconf", "-i"

    args = [
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--enable-3dnow",
    ]

    args << "--enable-darwin" unless OS.mac?
    args << "--enable-sse" if build.with? "sse"
    args << "--disable-rpath" if build.without? "rpath"

    system "./configure", *args

    system "make", "check"
    system "make", "install"
  end

  test do
  end
end
