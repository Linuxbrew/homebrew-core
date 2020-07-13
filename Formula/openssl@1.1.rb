class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1g.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.1.1g.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1g.tar.gz"
  sha256 "ddb04774f1e32f0c49751e21b67216ac87852ceb056b75209af2443400636d46"
  version_scheme 1

  bottle do
    sha256 "1926679569c6af5337de812d86f4dad2b21ff883ad3a5d2cd9e8836ac5ac7ffe" => :catalina
    sha256 "5c9d113393ff3efc95e5509175305fc9304fba35390a61915ed2864941c423f2" => :mojave
    sha256 "eebad96faa46489dc8bf8502b16ec0192f5ff9d803794c9744ad50352bfca0f7" => :high_sierra
    sha256 "6487415cb2902e5837927427a6b93a579bf5481652e526422d73f687bef41d3e" => :x86_64_linux
  end

  keg_only :shadowed_by_macos, "macOS provides LibreSSL"

  unless OS.mac?
    resource "cacert" do
      # homepage "http://curl.haxx.se/docs/caextract.html"
      url "https://curl.haxx.se/ca/cacert-2020-01-01.pem"
      mirror "https://gist.githubusercontent.com/dawidd6/16d94180a019f31fd31bc679365387bc/raw/ef02c78b9d6427585d756528964d18a2b9e318f7/cacert-2020-01-01.pem"
      sha256 "adf770dfd574a0d6026bfaa270cb6879b063957177a991d453ff1d302c02081f"
    end

    resource "Test::Harness" do
      url "https://cpan.metacpan.org/authors/id/L/LE/LEONT/Test-Harness-3.42.tar.gz"
      sha256 "0fd90d4efea82d6e262e6933759e85d27cbcfa4091b14bf4042ae20bab528e53"
    end

    resource "Test::More" do
      url "https://cpan.metacpan.org/authors/id/E/EX/EXODIST/Test-Simple-1.302175.tar.gz"
      sha256 "c8c8f5c51ad6d7a858c3b61b8b658d8e789d3da5d300065df0633875b0075e49"
    end
  end

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args
    %W[
      --prefix=#{prefix}
      --openssldir=#{openssldir}
      no-ssl3
      no-ssl3-method
      no-zlib
      #{[ENV.cppflags, ENV.cflags, ENV.ldflags].join(" ").strip unless OS.mac?}
      #{"enable-md2" unless OS.mac?}
    ]
  end

  def install
    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("Test::Harness").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
        system "make", "install"
      end

      resource("Test::More").stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", "CC=#{ENV.cc}"
        system "make", "install"
      end
    end

    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    ENV["PERL"] = Formula["perl"].opt_bin/"perl" if which("perl") == Formula["perl"].opt_bin/"perl"

    if OS.mac?
      arch_args = %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128]
    else
      arch_args = []
      if Hardware::CPU.intel?
        arch_args << (Hardware::CPU.is_64_bit? ? "linux-x86_64" : "linux-elf")
      elsif Hardware::CPU.arm?
        arch_args << (Hardware::CPU.is_64_bit? ? "linux-aarch64" : "linux-armv4")
      end
    end
    # Remove `no-asm` workaround when upstream releases a fix
    # See also: https://github.com/openssl/openssl/issues/12254
    arch_args << "no-asm" if Hardware::CPU.arm?

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "test" if OS.mac?
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    # See https://github.com/Linuxbrew/homebrew-core/pull/8891
    system "make", "test" unless OS.mac?
  end

  def openssldir
    etc/"openssl@1.1"
  end

  def post_install
    unless OS.mac?
      # Download and install cacert.pem from curl.haxx.se
      cacert = resource("cacert")
      cacert.fetch
      rm_f openssldir/"cert.pem"
      filename = Pathname.new(cacert.url).basename
      openssldir.install cacert.files(filename => "cert.pem")
      return
    end

    keychains = %w[
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    valid_certs = certs.select do |cert|
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout >/dev/null", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n") << "\n")
  end

  def caveats
    <<~EOS
      A CA file has been bootstrapped using certificates from the system
      keychain. To add additional certificates, place .pem files in
        #{openssldir}/certs

      and run
        #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate pkgetc/"openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system bin/"openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
