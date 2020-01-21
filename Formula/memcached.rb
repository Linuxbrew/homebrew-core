# memcached: Build a bottle for Linux
class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.20.tar.gz"
  sha256 "cfd7b023a9cefe7ae8a67184f51d841dbbf97994ed0e8a55e31ee092320ea1e4"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a03608101a7aa55a32ef05d945e852bfc22cbd4647c5a6d41d7957c022489e02" => :catalina
    sha256 "cca9f385ec7477a12f787aec8cb0da8a58f83c170e8ded061cbbdff75e158ccf" => :mojave
    sha256 "893bc856ebe459590a08c6acf9ad863d850413de804ddac8b65d1262c5dc2467" => :high_sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist; <<~EOS
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
        <string>#{opt_bin}/memcached</string>
        <string>-l</string>
        <string>localhost</string>
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
    pidfile = testpath/"memcached.pid"
    # Assumes port 11211 is not already taken
    if ENV["CI"]
      system bin/"memcached", "-u", "root", "--listen=0.0.0.0", "--daemon", "--pidfile=#{pidfile}"
    else
      system bin/"memcached", "--listen=localhost:11211", "--daemon", "--pidfile=#{pidfile}"
    end
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
