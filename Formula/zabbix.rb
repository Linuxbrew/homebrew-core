class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://downloads.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/4.4.7/zabbix-4.4.7.tar.gz"
  sha256 "497b8fe7905576d4d450c6fa486693c10d42915b6b55564f111957edcb9fec8d"
  revision 1 unless OS.mac?

  bottle do
    sha256 "1a203e1675c77976ff2c164d1b38279d37fa31ea0bd70087939d265be80f5f99" => :catalina
    sha256 "6d346a086dc6938e37bcb41eebc9343a7730b012696125cfe309c4d90f7a04a1" => :mojave
    sha256 "056f1fb839febcbb0c4fa2f76f627676184ecb5254c13489753ea08283aaccc5" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "pcre"

  def brewed_or_shipped(db_config)
    brewed_db_config = "#{HOMEBREW_PREFIX}/bin/#{db_config}"
    (File.exist?(brewed_db_config) && brewed_db_config) || which(db_config)
  end

  def install
    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre=#{Formula["pcre"].opt_prefix}
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--with-iconv=#{sdk}/usr" if OS.mac?

    if OS.mac? && MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "configure", "clock_gettime(CLOCK_REALTIME, &tp);",
                             "undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
