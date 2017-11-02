# This formula tracks 1.0.2 branch of OpenSSL, not the 1.1.0 branch. Due to
# significant breaking API changes in 1.1.0 other formulae will be migrated
# across slowly, so core will ship `openssl` & `openssl@1.1` for foreseeable.
class Openssl < Formula
  desc "SSL/TLS cryptography library"
  homepage "https://openssl.org/"
  url "https://www.openssl.org/source/openssl-1.0.2m.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/openssl-1.0.2m.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.openssl.org/source/openssl-1.0.2m.tar.gz"
  mirror "http://artfiles.org/openssl.org/source/openssl-1.0.2m.tar.gz"
  sha256 "8c6ff15ec6b319b50788f42c7abc2890c08ba5a1cdcd3810eb9092deada37b0f"

  bottle do
    sha256 "0eeee936b7f362ec5d2d844deb74ec92b79d3105445e5ca5e8767df4aabdebfd" => :high_sierra
    sha256 "b8d2658b3990ee55d48e56fadf47b9d6a619592742a99ae598b84ced4cd41372" => :sierra
    sha256 "7bf574dbaedac17813dca22efb201392f8503d644d796ddc9e370230ddc373b1" => :el_capitan
  end

  keg_only :provided_by_osx,
    "Apple has deprecated use of OpenSSL in favor of its own TLS and crypto libraries"

  option "without-test", "Skip build-time tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  resource "cacert" do
    # homepage "http://curl.haxx.se/docs/caextract.html"
    url "https://curl.haxx.se/ca/cacert-2017-01-18.pem"
    mirror "http://cdn.rawgit.com/sjackman/e4066d2cb6b45fbb6d213e676cb109d0/raw/58964378cb5eefe96cba245ef863c57fb2b480e0/cacert-2017-01-18.pem"
    sha256 "e62a07e61e5870effa81b430e1900778943c228bd7da1259dd6a955ee2262b47"
  end

  if OS.mac?
    depends_on "makedepend" => :build
  else
    depends_on "zlib"
    depends_on :perl => ["5.0", :build]
  end

  # Build without makedepend.
  patch do
    url "https://github.com/openssl/openssl/pull/1524.patch"
    sha256 "bc954e98673a78983e58da2fe6decfcf94b38eeec78d8b456ca716a539f78b06"
  end unless OS.mac?

  def arch_args
    return {
      :i386 => %w[linux-generic32],
      :x86_64 => %w[linux-x86_64],
      :arm => %w[linux-armv4],
    } if OS.linux?

    {
      :x86_64 => %w[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128],
      :i386 => %w[darwin-i386-cc],
    }
  end

  def configure_args; %W[
    --prefix=#{prefix}
    --openssldir=#{openssldir}
    no-ssl2
    zlib-dynamic
    shared
    enable-cms
    #{[ENV.cppflags, ENV.cflags, ENV.ldflags].join(" ").strip unless OS.mac?}
  ]
  end

  def install
    # openssl does not in fact require an executable stack.
    ENV.append_to_cflags "-Wa,--noexecstack" unless OS.mac?

    # OpenSSL will prefer the PERL environment variable if set over $PATH
    # which can cause some odd edge cases & isn't intended. Unset for safety,
    # along with perl modules in PERL5LIB.
    ENV.delete("PERL")
    ENV.delete("PERL5LIB")

    # Load zlib from an explicit path instead of relying on dyld's fallback
    # path, which is empty in a SIP context. This patch will be unnecessary
    # when we begin building openssl with no-comp to disable TLS compression.
    # https://langui.sh/2015/11/27/sip-and-dlopen
    inreplace "crypto/comp/c_zlib.c",
              'zlib_dso = DSO_load(NULL, "z", NULL, 0);',
              'zlib_dso = DSO_load(NULL, "/usr/lib/libz.dylib", NULL, DSO_FLAG_NO_NAME_TRANSLATION);' if OS.mac?

    if MacOS.prefer_64_bit?
      arch = Hardware::CPU.arch_64_bit
    else
      arch = Hardware::CPU.arch_32_bit
    end

    ENV.deparallelize
    system "perl", "./Configure", *(configure_args + arch_args[arch])
    system "make", "depend"
    system "make"
    if which "cmp"
      system "make", "test" if build.with?("test")
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end

    system "make", "install", "MANDIR=#{man}", "MANSUFFIX=ssl"
  end

  def openssldir
    etc/"openssl"
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
      IO.popen("#{bin}/openssl x509 -inform pem -checkend 0 -noout", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end

      $CHILD_STATUS.success?
    end

    openssldir.mkpath
    (openssldir/"cert.pem").atomic_write(valid_certs.join("\n"))
  end

  def caveats; <<~EOS
    A CA file has been bootstrapped using certificates from the SystemRoots
    keychain. To add additional certificates (e.g. the certificates added in
    the System keychain), place .pem files in
      #{openssldir}/certs

    and run
      #{opt_bin}/c_rehash
    EOS
  end

  test do
    # Make sure the necessary .cnf file exists, otherwise OpenSSL gets moody.
    assert_predicate HOMEBREW_PREFIX/"etc/openssl/openssl.cnf", :exist?,
            "OpenSSL requires the .cnf file for some functionality"

    # Check OpenSSL itself functions as expected.
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "e2d0fe1585a63ec6009c8016ff8dda8b17719a637405a4e23c0ff81339148249"
    system "#{bin}/openssl", "dgst", "-sha256", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end
