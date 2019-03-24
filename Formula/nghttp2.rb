# nghttp2: Build a bottle for Linuxbrew
class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.37.0/nghttp2-1.37.0.tar.xz"
  sha256 "aa090b164b17f4b91fe32310a1c0edf3e97e02cd9d1524eef42d60dd1e8d47b7"

  bottle do
    sha256 "336eb6bf2788bcf43c47e40d31e20af00685695baa74a821e4fd5bf5485bf48d" => :mojave
    sha256 "c4b73515d2c207657f4d8a69b64f772d51208d069ae1f0cbd005f6d287d979f8" => :high_sierra
    sha256 "e8d38af114792011b03827d512ddf9a1f9c2fe48c641f18e04bbc00d94277057" => :sierra
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
  depends_on "openssl"
  depends_on "zlib" unless OS.mac?

  unless OS.mac?
    patch do
      # Fix: shrpx_api_downstream_connection.cc:57:3: error: array must be initialized with a brace-enclosed initializer
      url "https://gist.githubusercontent.com/iMichka/5dda45fbad3e70f52a6b4e7dfd382969/raw/19797e17926922bdd1ef21a47e162d8be8e2ca65/nghttp2?full_index=1"
      sha256 "0759d448d4b419911c12fa7d5cbf1df2d6d41835c9077bf3accf9eac58f24f12"
    end
  end

  def install
    # Reduce memory usage below 4 GB for Circle CI.
    ENV["MAKEFLAGS"] = "-j8" if ENV["CIRCLECI"]

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
