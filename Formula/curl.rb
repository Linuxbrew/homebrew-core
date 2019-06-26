class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.65.1.tar.bz2"
  mirror "http://curl.mirror.anstey.ca/curl-7.65.1.tar.bz2"
  sha256 "cbd36df60c49e461011b4f3064cff1184bdc9969a55e9608bf5cadec4686e3f7"

  bottle do
    cellar :any
    sha256 "6755d72e9f70a293983532324bf20bdca96f1e9863a1cfaa77f22a938332b9ae" => :mojave
    sha256 "821cf46a2d891d0c62fa36ee55cb873a751ce8081a4cd9d03ad5de04941891d1" => :high_sierra
    sha256 "38bed646688ef5eaff0f68e232f5909d678cf7c9459f17b3f310462a84a81539" => :sierra
    sha256 "b54ae91a46d8554fc7062f0a2d6697550ce4bb53c36fee66466a787f2e3aad10" => :x86_64_linux
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
  uses_from_macos "openssl"

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
