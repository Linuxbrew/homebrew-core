class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.36.0/nghttp2-1.36.0.tar.xz"
  sha256 "e9bb86157b88eda5a6844a232e039febbb52c1aa44b640acbbfabe729b8287fc"

  bottle do
    sha256 "62826dd93311e84bfd5cdabb4d653586529df4f762a4389e347d5f1eb010f6c9" => :mojave
    sha256 "3436a6978dff3ad3dfca21e6d84b454e2f034000ec3ede30b3425ff737484114" => :high_sierra
    sha256 "721126c6bc8725b891573dd69f94903df3cb3ff6125e735ec163c0308a79b389" => :sierra
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
