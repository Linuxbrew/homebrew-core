# nghttp2: Build a bottle for Linuxbrew
class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.39.2/nghttp2-1.39.2.tar.xz"
  sha256 "a2d216450abd2beaf4e200c168957968e89d602ca4119338b9d7ab059fd4ce8b"
  revision 1

  bottle do
    sha256 "e2c689aaea97495a120f6fd923484a061a016bfcaa9084689e4737f41d73c964" => :mojave
    sha256 "fd9f5886356495b019830d38e3d041e8bc524a80a92ba4ccc811badb3ee9b3ee" => :high_sierra
    sha256 "55ea2f944214fad0b946a194d0e43c256345290581670922c397d187a560ee13" => :sierra
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  unless OS.mac?
    patch do
      # Fix: shrpx_api_downstream_connection.cc:57:3: error: array must be initialized with a brace-enclosed initializer
      url "https://gist.githubusercontent.com/iMichka/5dda45fbad3e70f52a6b4e7dfd382969/raw/19797e17926922bdd1ef21a47e162d8be8e2ca65/nghttp2?full_index=1"
      sha256 "0759d448d4b419911c12fa7d5cbf1df2d6d41835c9077bf3accf9eac58f24f12"
    end
  end

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    # Fails on Linux:
    system "make", "check" if OS.mac?
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end
