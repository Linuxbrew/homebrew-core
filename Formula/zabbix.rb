class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/stable/4.4.8/zabbix-4.4.8.tar.gz"
  sha256 "c0562245c75fc86c2c22d9a8e521c147dea832056b869d27488ea6130a253651"

  bottle do
    sha256 "77400bbc21ca6a942fc1461915c0435ea70f08fd3df8e8bc3f7a484c847718eb" => :catalina
    sha256 "65886b1277abf913aafc16346f051a1a731942861ff1e61c8ab50b50deba6c18" => :mojave
    sha256 "1eceb57e7760d5eae7fac886a5aacf7e98efd9cf87e60bc014eaa84cc0091269" => :high_sierra
    sha256 "cebfb729d9f86898f20c6206e1a9c564ec1ae3c547fd71832dad2f380726886d" => :x86_64_linux
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
