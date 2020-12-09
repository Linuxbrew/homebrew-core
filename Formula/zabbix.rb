class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/zabbix-5.0.6.tar.gz"
  sha256 "53c55ae9a0898b7e523712db0fe2daf00d88d6df7188ad14e8ea07d8b3b2cdc8"
  license "GPL-2.0-or-later"

  # As of writing, the Zabbix SourceForge repository is missing the latest
  # version (4.4.8), so we have to check for the newest version on the Zabbix
  # CDN index page instead. Unfortunately, the versions are separated into
  # folders for a given major/minor version, so this will quietly stop being
  # a proper check sometime in the future and need to be updated.
  livecheck do
    url "https://cdn.zabbix.com/zabbix/sources/stable/5.0/"
    regex(/href=.*?zabbix[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "21d6a09c7b904a9ecbe7147632e8da85c9f46e090147601c3e46cb3f758ef4c0" => :big_sur
    sha256 "8ae1494fdea3da3695c8a0f1089f348a54817443dddd82115a017b5f4481a646" => :catalina
    sha256 "79492e64767727eb55008d1ccb1ebbfbbf95b00db2483084e44e5a0690248804" => :mojave
    sha256 "a381a24ffcf7ecbc6970d9c01586400d7fc2947329be1cbe19c8894fdd60d0d8" => :x86_64_linux
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
