class Profanity < Formula
  desc "Console based XMPP client"
  homepage "https://profanity-im.github.io"
  url "https://profanity-im.github.io/profanity-0.10.0.tar.gz"
  sha256 "4a05e32590f9ec38430e33735bd02cfa199b257922b4116613f23912ca39ff8c"
  license "GPL-3.0-or-later"

  bottle do
    sha256 "d3438a7bee47f6fab9d4a20c3523e4bb0fd02dd8438e7d566aaed6ee6baf2e8b" => :big_sur
    sha256 "15730bfe363723c0fca635beba9112c4a2883739a024f86e84ab07074da50287" => :catalina
    sha256 "181ed4e8ae4eaad8bf43a99dc1cec785094b213c5e8409e3f9959e3f2e67fd41" => :mojave
  end

  head do
    url "https://github.com/profanity-im/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build unless OS.mac?
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gpgme"
  depends_on "libotr"
  depends_on "libsignal-protocol-c"
  depends_on "libstrophe"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "curl"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin" unless OS.mac?

    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/profanity", "-v"
  end
end
