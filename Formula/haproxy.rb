class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.2/src/haproxy-2.2.1.tar.gz"
  sha256 "536552af1316807c01de727ad3dac84b3a2f5285db32e9bfdfe234e47ff9d124"

  bottle do
    cellar :any
    sha256 "b9eac84a724b1701a68c79e17a93a0059d1506861fa830721ae402ccf72c94d9" => :catalina
    sha256 "7c1614d86a732a4f94cc86d228309ca1bee7ae710e150c64a84c9bd5ad3103fe" => :mojave
    sha256 "fbb62e5302dc437fc3f312e0536d3a602351cebabd21eca7b83ee7e54dd432da" => :high_sierra
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
