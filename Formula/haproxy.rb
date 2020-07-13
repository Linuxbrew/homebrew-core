class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.2/src/haproxy-2.2.0.tar.gz"
  sha256 "3c1a87160eea40e067f1e2813bfe692280a10c455beb17a8ee7fae11e4223274"

  bottle do
    cellar :any
    sha256 "0321c84dd236915de93bf218f7b6f7616c85ecf058639760a94d24ac9d0c0d83" => :catalina
    sha256 "da00b9480533821e1b34bffa7a2d602ddc5f96e03aaa439ea2bae0349549a858" => :mojave
    sha256 "501ccc11c70474ef69d4544416a5a7777a6aeb9be0249f596b944c6cb12e8a68" => :high_sierra
    sha256 "858243b762b4b13d390e5ee147d14227f05243afe8f57ab28ce6ed22c799f4aa" => :x86_64_linux
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %W[
      TARGET=#{OS.mac? ? "generic" : "linux-glibc"}
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    args << "USE_KQUEUE=1" if OS.mac?

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options :manual => "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/haproxy</string>
            <string>-f</string>
            <string>#{etc}/haproxy.cfg</string>
          </array>
          <key>StandardErrorPath</key>
          <string>#{var}/log/haproxy.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/haproxy.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"haproxy", "-v"
  end
end
