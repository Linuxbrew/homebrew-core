# openssl@1.1: Build a bottle for Linuxbrew
class OpensslAT11 < Formula
  desc "Cryptography and SSL/TLS Toolkit"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.1.1d.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl@1.1--1.1.1d.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.1.1d.tar.gz"
  sha256 "1e3a91bc1f9dfce01af26026f856e064eab4c8ee0a8f457b5ae30b40b8b711f2"
  version_scheme 1

  bottle do
    sha256 "104ef018b7bb8fcc49f57e5a60359a28a02d480d85a959e6141394b0571cbb28" => :mojave
    sha256 "c7681ee40cb3680cd9fafcdb092bde153b9d4903907d67858baa5f19025f927b" => :high_sierra
    sha256 "a95d756e9aa3a8d118833f9083112048bf635f20c33943de04163bdcf7412328" => :sierra
  end

  if OS.mac?
    keg_only :provided_by_macos,
      "openssl/libressl is provided by macOS so don't link an incompatible version"
  else
    keg_only :versioned_formula
  end

  unless OS.mac?
    resource "cacert" do
      # homepage "http://curl.haxx.se/docs/caextract.html"
      url "https://curl.haxx.se/ca/cacert-2017-01-18.pem"
      mirror "http://cdn.rawgit.com/sjackman/e4066d2cb6b45fbb6d213e676cb109d0/raw/58964378cb5eefe96cba245ef863c57fb2b480e0/cacert-2017-01-18.pem"
      sha256 "e62a07e61e5870effa81b430e1900778943c228bd7da1259dd6a955ee2262b47"
    end
  end

  # SSLv2 died with 1.1.0, so no-ssl2 no longer required.
  # SSLv3 & zlib are off by default with 1.1.0 but this may not
  # be obvious to everyone, so explicitly state it for now to
  # help debug inevitable breakage.
  def configure_args; %W[
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
    # This could interfere with how we expect OpenSSL to build.
    ENV.delete("OPENSSL_LOCAL_CONFIG_DIR")

    # This ensures where Homebrew's Perl is needed the Cellar path isn't
    # hardcoded into OpenSSL's scripts, causing them to break every Perl update.
    # Whilst our env points to opt_bin, by default OpenSSL resolves the symlink.
    if which("perl") == Formula["perl"].opt_bin/"perl"
      ENV["PERL"] = Formula["perl"].opt_bin/"perl"
    end

    unless OS.mac?
      arch_args = %w[linux-x86_64]
    end
    if OS.mac?
      arch_args = %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128]
    end

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args)
    system "make"
    system "make", "test" if OS.mac?
    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
    # See https://github.com/Linuxbrew/homebrew-core/pull/8891
    system "make", "test" if build.with?("test") && !OS.mac?
  end

  def openssldir
    etc/"openssl@1.1"
  end

  def post_install
    unless OS.mac?
      # Download and install cacert.pem from curl.haxx.se
      cacert = resource("cacert")
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

  def caveats; <<~EOS
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
  EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/openssl@1.1/openssl.cnf", :exist?,
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
