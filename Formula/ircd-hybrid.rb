class IrcdHybrid < Formula
  desc "High-performance secure IRC server"
  homepage "http://www.ircd-hybrid.org/"
  url "https://downloads.sourceforge.net/project/ircd-hybrid/ircd-hybrid/ircd-hybrid-8.2.30/ircd-hybrid-8.2.30.tgz"
  sha256 "f92d837306b11621b25eb449b341207c80ba634280bd7c29b2b7be3019b259f1"

  bottle do
    sha256 "4f9af65b03a153f6f6ff92f96b6fe7a14784f8dce6852656cc0f130c88b2eebc" => :catalina
    sha256 "68d2fafdf7448feee3fb0e04ff613205ddbee4e8beb45b179b526e44397d4de7" => :mojave
    sha256 "c352eba478cec35087af2da77fe3408626c1634621a4be30db75ca48382a9873" => :high_sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "ircd-irc2", :because => "both install an `ircd` binary"

  # ircd-hybrid needs the .la files
  skip_clean :la

  patch do
    url "https://github.com/ircd-hybrid/ircd-hybrid/commit/f2428b2cc215b2227f10840ba63a85b2a812f585.patch?full_index=1"
    sha256 "7073595aba16ff77484a94617b507552bf146032e4e1cbfff4675d83015360e3"
  end

  def install
    ENV.deparallelize # build system trips over itself

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--enable-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
    etc.install "doc/reference.conf" => "ircd.conf"
  end

  def caveats
    <<~EOS
      You'll more than likely need to edit the default settings in the config file:
        #{etc}/ircd.conf
    EOS
  end

  plist_options :manual => "ircd"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <false/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/ircd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/ircd.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    # Won't run as root
    return if Process.uid.zero?

    system "#{bin}/ircd", "-version"
  end
end
