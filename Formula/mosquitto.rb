class Mosquitto < Formula
  desc "Message broker implementing the MQTT protocol"
  homepage "https://mosquitto.org/"
  url "https://mosquitto.org/files/source/mosquitto-2.0.0.tar.gz"
  sha256 "ca8c21d1b04037df27639de9ea8f82fa73e1cbd24e83e6394ed67b537c4b6d86"
  # dual-licensed under EPL-1.0 and EDL-1.0 (Eclipse Distribution License v1.0),
  # EDL-1.0 is not in the SPDX list
  license "EPL-1.0"

  livecheck do
    url "https://mosquitto.org/download/"
    regex(/href=.*?mosquitto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5adb61015b96b7f43b715e321a5bf885208b049914d259d99d9e8f0dd07297df" => :big_sur
    sha256 "631f0c97205f0cb200b725922197d2bf9e112421282c8d5e29a0f505fa389140" => :catalina
    sha256 "43341fe06600105477d2d6ec6c8a757ea848dc607c10771aaf3138239fcaa0a2" => :mojave
    sha256 "0da12b8ed6ffb16b62186cf1b141b372a103cb502104b0962db3a2e5802f2081" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libwebsockets"
  depends_on "openssl@1.1"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DWITH_WEBSOCKETS=ON"
    system "make", "install"
  end

  def post_install
    (var/"mosquitto").mkpath
  end

  def caveats
    <<~EOS
      mosquitto has been installed with a default configuration file.
      You can make changes to the configuration by editing:
          #{etc}/mosquitto/mosquitto.conf
    EOS
  end

  plist_options manual: "mosquitto -c #{HOMEBREW_PREFIX}/etc/mosquitto/mosquitto.conf"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/mosquitto</string>
          <string>-c</string>
          <string>#{etc}/mosquitto/mosquitto.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>WorkingDirectory</key>
        <string>#{var}/mosquitto</string>
      </dict>
      </plist>
    EOS
  end

  test do
    quiet_system "#{sbin}/mosquitto", "-h"
    assert_equal 3, $CHILD_STATUS.exitstatus
  end
end
