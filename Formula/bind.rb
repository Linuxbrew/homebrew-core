class Bind < Formula
  desc "Implementation of the DNS protocols"
  homepage "https://www.isc.org/bind/"

  # BIND releases with even minor version numbers (9.14.x, 9.16.x, etc) are
  # stable. Odd-numbered minor versions are for testing, and can be unstable
  # or buggy. They are not suitable for general deployment. We have to use
  # "version_scheme" because someone upgraded to 9.15.0, and required a
  # downgrade.

  url "https://downloads.isc.org/isc/bind9/9.16.15/bind-9.16.15.tar.xz"
  sha256 "98b6f432d878a7bf8f57eb7b3c28be27278cf6b9989154bfe6c81104b38e7839"
  license "MPL-2.0"
  version_scheme 1
  head "https://gitlab.isc.org/isc-projects/bind9.git"

  # BIND indicates stable releases with an even-numbered minor (e.g., x.2.x)
  # and the regex below only matches these versions.
  livecheck do
    url "https://www.isc.org/download/"
    regex(/href=.*?bind[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "a1cbee35346d799735ef7be164efa48123ddf13ce7c052f24a8c109593616931"
    sha256 big_sur:       "0f2845f4dabf9941aaa6cd7c0dad99e7ac2e59ca7081b4fdd413056b0d69f0dc"
    sha256 catalina:      "036eaa91967bac97fa1dd141404b39f6f209b414bb6d8036fefcf86378637a63"
    sha256 mojave:        "af7ad47045748051e6d747063857c2097306a468af735e1a2498be87b9084bb9"
    sha256 x86_64_linux:  "55a8d57bfce2d834869359ab5c4e758c28c7034e49a6ce68ce729d418a3669d9"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libidn2"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  def install
    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    vendor_site_packages = libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages
    resources.each do |r|
      r.stage do
        system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # Fix "configure: error: xml2-config returns badness"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{pkgetc}",
      "--with-json-c",
      "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
      "--with-libjson=#{Formula["json-c"].opt_prefix}",
      "--with-python-install-dir=#{vendor_site_packages}",
      "--with-python=#{Formula["python@3.9"].opt_bin}/python3",
      "--without-lmdb",
      "--with-libidn2=#{Formula["libidn2"].opt_prefix}",
    ]
    on_linux do
      args << "--disable-linux-caps"
    end
    system "./configure", *args

    system "make"
    system "make", "install"

    (buildpath/"named.conf").write named_conf
    system "#{sbin}/rndc-confgen", "-a", "-c", "#{buildpath}/rndc.key"
    pkgetc.install "named.conf", "rndc.key"
  end

  def post_install
    (var/"log/named").mkpath
    (var/"named").mkpath
  end

  def named_conf
    <<~EOS
      logging {
          category default {
              _default_log;
          };
          channel _default_log {
              file "#{var}/log/named/named.log" versions 10 size 1m;
              severity info;
              print-time yes;
          };
      };

      options {
          directory "#{var}/named";
      };
    EOS
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>EnableTransactions</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/named</string>
          <string>-f</string>
          <string>-L</string>
          <string>#{var}/log/named/named.log</string>
        </array>
        <key>ServiceIPC</key>
        <false/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"dig", "-v"
    system bin/"dig", "brew.sh"
    system bin/"dig", "ü.cl"
  end
end
