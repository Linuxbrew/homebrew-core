class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.42.0/nghttp2-1.42.0.tar.xz"
  sha256 "c5a7f09020f31247d0d1609078a75efadeccb7e5b86fc2e4389189b1b431fe63"
  license "MIT"

  bottle do
    sha256 "05a32909b92b1e546c20d5722cf0ede751757d6865de0e8a3c030609b36406bc" => :big_sur
    sha256 "52cdad0d7525cd28ce3e1b0efd9c677457dc6c51a729ae9f760d2a55bde51e1a" => :catalina
    sha256 "5459e23d7214299f8e227a0fe204f43baca8fad45a845990c165c7db6ce1b192" => :mojave
    sha256 "8cfd4a7e92c84e63c838fb3ac1db0f63e84805f8939578411ff8d2cdf4cc6024" => :x86_64_linux
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
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  unless OS.mac?
    patch do
      # Fix: shrpx_api_downstream_connection.cc:57:3: error:
      # array must be initialized with a brace-enclosed initializer
      url "https://gist.githubusercontent.com/iMichka/5dda45fbad3e70f52a6b4e7dfd382969/raw/" \
          "19797e17926922bdd1ef21a47e162d8be8e2ca65/nghttp2?full_index=1"
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
