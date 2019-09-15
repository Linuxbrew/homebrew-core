# pulseaudio: Build a bottle for Linuxbrew
# pulseaudio: Build a bottle for Linuxbrew
class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-13.0.tar.xz"
  sha256 "961b23ca1acfd28f2bc87414c27bb40e12436efcf2158d29721b1e89f3f28057"

  bottle do
    sha256 "819cb5b8dd86715db2285f647b1742611dd2a802447aea637f05adae33a6056b" => :mojave
    sha256 "a5c5442b2118b9e3e3b2cbd8a8a700a121e9264b11c7096a3b3c42ce780a7a0b" => :high_sierra
    sha256 "bc42617a58074e5631eae20559f6a043ee87c8dcfd9944ac45b47467a3cdca66" => :sierra
  end

  head do
    url "https://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  unless OS.mac?
    depends_on "m4" => :build
    depends_on "expat"
    depends_on "glib"
    depends_on "libcap"

    # Depends on XML::Parser
    # Using the host's Perl interpreter to install XML::Parser fails when using brew's glibc.
    # Use brew's Perl interpreter instead.
    # See Linuxbrew/homebrew-core#8148
    depends_on "perl" => :build
    resource "XML::Parser" do
      url "https://cpan.metacpan.org/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
      sha256 "1ae9d07ee9c35326b3d9aad56eae71a6730a73a116b9fe9e8a4758b7cc033216"
    end
  end

  def install
    unless OS.mac?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resources.each do |res|
        res.stage do
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
          system "make", "PERL5LIB=#{ENV["PERL5LIB"]}", *("CC=#{ENV.cc}" unless OS.mac?)
          system "make", "install"
        end
      end
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-neon-opt
      --disable-nls
      --disable-x11
    ]

    if OS.mac?
      args << "--with-mac-sysroot=#{MacOS.sdk_path})"
      args << "--with-mac-version-min=#{MacOS.version}"
    end

    # Perl depends on gdbm.
    # If the dependency of pulseaudio on perl is build-time only,
    # pulseaudio detects and links gdbm at build-time, but cannot locate it at run-time.
    # Thus, we have to
    #  - specify not to use gdbm, or
    #  - add a dependency on gdbm if gdbm is wanted (not implemented).
    # See Linuxbrew/homebrew-core#8148
    args << "--with-database=simple" unless OS.mac?

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  plist_options :manual => "pulseaudio"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/pulseaudio</string>
        <string>--start</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
