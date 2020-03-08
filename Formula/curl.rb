class Curl < Formula
  desc "Get a file from an HTTP, HTTPS or FTP server"
  homepage "https://curl.haxx.se/"
  url "https://curl.haxx.se/download/curl-7.69.0.tar.bz2"
  sha256 "668d451108a7316cff040b23c79bc766e7ed84122074e44f662b8982f2e76739"
  revision 2 unless OS.mac?

  bottle do
    sha256 "24aa9504342f77774aee3567b70b5067bf610fcdb5863cd0791ecaec67a8fa1f" => :catalina
    sha256 "d0d9389ecd80e156f43bbbec2cdf90a09502f4bd300b74868a9bb82358e80e58" => :mojave
    sha256 "540af1e3466f38cc2fe0a4d9cde8e3cf11b644dba4bc9aa2e97a0f4ecca142a0" => :high_sierra
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
  depends_on "openssl@1.1" unless OS.mac?

  uses_from_macos "zlib"

  # TODO: Remove with next release after 7.69.0
  unless OS.mac?
    patch do
      url "https://github.com/curl/curl/commit/8aa04e9a24932b830bc5eaf6838dea5a3329341e.patch"
      sha256 "ea52049e73581acc3e3bf795010c6e11a928ac75380dd6f5dbb32c19b8dd0a4e"
    end

    patch do
      url "https://github.com/curl/curl/commit/e040146f22608fd92c44be2447a6505141a8a867.patch"
      sha256 "22b7faa70902820e447a22c28a830e917359c64d09d92505d728105a3ce4497b"
    end
  end

  def install
    system "./buildconf" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-secure-transport
    ]

    if OS.mac?
      args << "--with-darwinssl"
      args << "--without-ca-bundle"
      args << "--without-ca-path"
    else
      ENV.prepend_path "PKG_CONFIG_PATH", "#{Formula["openssl@1.1"].opt_lib}/pkgconfig"
      args << "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"
      args << "--with-ca-bundle=#{etc}/openssl@1.1/cert.pem"
      args << "--with-ca-path=#{etc}/openssl@1.1/certs"
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
