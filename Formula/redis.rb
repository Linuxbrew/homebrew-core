class Redis < Formula
  desc "Persistent key-value database, with built-in net interface"
  homepage "https://redis.io/"
  url "http://download.redis.io/releases/redis-6.0.5.tar.gz"
  sha256 "42cf86a114d2a451b898fcda96acd4d01062a7dbaaad2801d9164a36f898f596"
  license "BSD-3-Clause"
  head "https://github.com/redis/redis.git", :branch => "unstable"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f0633ca26dce126e3dddc8cc296bc32d58326fed74cc5396b35fb1e23f738f4" => :catalina
    sha256 "b20a36bcfef6c929eec0f166143330ca54cc08d4581a8fe69a616b89d6c7f2f5" => :mojave
    sha256 "749adb93b5e42cbfbdd14f1ae1567d73e1ecbf7e0f264f04dc86c1b10a192308" => :high_sierra
    sha256 "0c4ada876b110fdc18ac041ebd50378a7378069aaae6b68f13ce64786a4a8593" => :x86_64_linux
  end

  depends_on "openssl@1.1"

  patch do
    # Remove when upstream fix is released
    # https://github.com/redis/redis/pull/7453
    url "https://github.com/redis/redis/pull/7453.diff?full_index=1"
    sha256 "e1df0543442b75fea67a43eeddade50097d655fe3fef948840bf9d99bb63c157"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "CC=#{ENV.cc}", "BUILD_TLS=yes"

    %w[run db/redis log].each { |p| (var/p).mkpath }

    # Fix up default conf file to match our paths
    inreplace "redis.conf" do |s|
      s.gsub! "/var/run/redis.pid", var/"run/redis.pid"
      s.gsub! "dir ./", "dir #{var}/db/redis/"
      s.sub!  /^bind .*$/, "bind 127.0.0.1 ::1"
    end

    etc.install "redis.conf"
    etc.install "sentinel.conf" => "redis-sentinel.conf"
  end

  plist_options :manual => "redis-server #{HOMEBREW_PREFIX}/etc/redis.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/redis-server</string>
            <string>#{etc}/redis.conf</string>
            <string>--daemonize no</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/redis.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/redis.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"redis-server", "--test-memory", "2"
    %w[run db/redis log].each { |p| assert_predicate var/p, :exist?, "#{var/p} doesn't exist!" }
  end
end
