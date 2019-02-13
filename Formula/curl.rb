class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.64.0.tar.bz2"
  mirror "http://curl.mirror.anstey.ca/curl-7.64.0.tar.bz2"
  sha256 "d573ba1c2d1cf9d8533fadcce480d778417964e8d04ccddcc76e591d544cf2eb"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any
    sha256 "e5fa214a00a00fa80d76bd05db14e5c176a6be7bedeb86d748f5aa2969344f88" => :mojave
    sha256 "7349c533e22662c05ef5039696c3e8a7cd8d8a696797040c9c6bf27134662feb" => :high_sierra
    sha256 "0191dd2c0b129db3fcc10de4e5f61891ebe481a376cec04f8a2a4df5b389e9cb" => :sierra
    sha256 "778732db7ac6775a6f18eb039957f7abbac677c41972ffd49ae048cb68e03165" => :x86_64_linux
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX} when built with OpenSSL."
    satisfy { OS.mac? || HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
  end

  head do
    url "https://github.com/curl/curl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "openssl" unless OS.mac?

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    if OS.mac?
      args << "--with-darwinssl"
      args << "--without-ca-bundle"
      args << "--without-ca-path"
    else
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl"].opt_lib}/pkgconfig"
      args << "--with-ssl=#{Formula["openssl"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl/cert.pem"
      args << "--with-ca-path=#{etc}/openssl/certs"
      args << "--disable-ares"
      args << "--disable-ldap"
    end

    system "./configure", *args
    system "make", "install"
    system "make", "install", "-C", "scripts"
    libexec.install "lib/mk-ca-bundle.pl"
  end

  test do
    # Fetch the curl tarball and see that the checksum matches.
    # This requires a network connection, but so does Homebrew in general.
    filename = (testpath/"test.tar.gz")
    system "#{bin}/curl", "-L", stable.url, "-o", filename
    filename.verify_checksum stable.checksum

    system libexec/"mk-ca-bundle.pl", "test.pem"
    assert_predicate testpath/"test.pem", :exist?
    assert_predicate testpath/"certdata.txt", :exist?
  end
end
