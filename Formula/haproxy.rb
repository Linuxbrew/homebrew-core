class Haproxy < Formula
  desc "Reliable, high performance TCP/HTTP load balancer"
  homepage "https://www.haproxy.org/"
  url "https://www.haproxy.org/download/2.3/src/haproxy-2.3.10.tar.gz"
  sha256 "9946e0cfc83f29072b3431e37246221cf9d4a9d28a158c075714d345266f4f35"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  livecheck do
    url :homepage
    regex(/href=.*?haproxy[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "84029114d1b57c063945f6cd2c41dc546ca3ea4f508f5974359d7fda3cf4bc93"
    sha256 cellar: :any,                 big_sur:       "99ce3991d747cce449f08245a16993dd3dabc34c406daac209ff90730f3d06b5"
    sha256 cellar: :any,                 catalina:      "87165db5388506d060e0f3fbafd7b7827e9ceeb9ec6cbe55221c2cbebe135fcc"
    sha256 cellar: :any,                 mojave:        "db4c0571bec487919c0a734c0249588296e331bda6f6bafb8ae5b5ecf9607757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bfbffd89936f7eada4889ec62c64c0374f33c71d1748ed0733a57554f112d168"
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def install
    args = %w[
      USE_POLL=1
      USE_PCRE=1
      USE_OPENSSL=1
      USE_THREAD=1
      USE_ZLIB=1
      ADDLIB=-lcrypto
    ]
    on_macos do
      args << "TARGET=generic"
      # BSD only:
      args << "USE_KQUEUE=1"
    end
    on_linux do
      args << "TARGET=linux-glibc"
    end

    # We build generic since the Makefile.osx doesn't appear to work
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", *args
    man1.install "doc/haproxy.1"
    bin.install "haproxy"
  end

  plist_options manual: "haproxy -f #{HOMEBREW_PREFIX}/etc/haproxy.cfg"

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
