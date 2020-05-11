class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.13.0/pgbouncer-1.13.0.tar.gz"
  sha256 "4cb821c95f05625594355bba89c139f2a4e062af221c2135bf0526b920c89d31"

  bottle do
    cellar :any
    sha256 "3cb7ca701bfa0ae8ae502bb1c394de78d3cadd3fccdc2c1d99409c5c20c3e9a5" => :catalina
    sha256 "f5a40df1196249bd3b1f6b8bb3baee7cd77a748a1238b0a777902add325dd4c0" => :mojave
    sha256 "d8cc229281484ebffbaaca3b7fbc00c35394d7dc415a969be8696e1e4cb15c87" => :high_sierra
    sha256 "2ccb53732748c6792bb31d43ddf8b3c9d2bdd24f6cd402d6b6fc1b011bffb435" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub! /logfile = .*/, "logfile = #{var}/log/pgbouncer.log"
      s.gsub! /pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid"
      s.gsub! /auth_file = .*/, "auth_file = #{etc}/userlist.txt"
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def caveats
    <<~EOS
      The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
      will need to edit it for your particular setup. See:
      https://pgbouncer.github.io/config.html

      The auth_file option should point to the #{etc}/userlist.txt file which
      can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  plist_options :manual => "pgbouncer -q #{HOMEBREW_PREFIX}/etc/pgbouncer.ini"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pgbouncer</string>
          <string>-q</string>
          <string>#{etc}/pgbouncer.ini</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end
