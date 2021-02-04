class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.2.tar.xz"
  sha256 "75d3f7742c1ae449049a4c88900e454b8b350ecaa8c544f3488a2562a9ff66f1"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "efcbf144da932e05394e9768bf27dfa1908dbb17f4b7c52f49e56c791dd51860"
    sha256 big_sur:       "79684acaac85e9b1b7de55fc7659844d9508c6264faa0aac311e0d8eaf4056b0"
    sha256 catalina:      "e1c181ae27f945ceee403e2e2ec80f44aebd52ac44b8e63140c1c9d2083a643b"
    sha256 mojave:        "ae0d2ec72fc10a895c7efc330174abef08458576ed847fb4547301a2d8cc147e"
    sha256 x86_64_linux:  "0df43644558f381d34ba673490a1717ca4b7bbbee961bc5681c77996cc67d9a9"
  end

  head do
    url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git"

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
    depends_on "dbus"
    depends_on "glib"
    depends_on "libcap"
  end

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  unless OS.mac?
    # Depends on XML::Parser
    # Using the host's Perl interpreter to install XML::Parser fails when using brew's glibc.
    # Use brew's Perl interpreter instead.
    # See Linuxbrew/homebrew-core#8148
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

    unless OS.mac?
      # Perl depends on gdbm.
      # If the dependency of pulseaudio on perl is build-time only,
      # pulseaudio detects and links gdbm at build-time, but cannot locate it at run-time.
      # Thus, we have to
      #  - specify not to use gdbm, or
      #  - add a dependency on gdbm if gdbm is wanted (not implemented).
      # See Linuxbrew/homebrew-core#8148
      args << "--with-database=simple"

      # Tell pulseaudio to use the brewed udev rules dir instead of the system one,
      # which it does not have permission to modify
      args << "--with-udev-rules-dir=#{lib}/udev/rules.d"
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"

    # https://stackoverflow.com/questions/56309056/is-gschemas-compiled-architecture-specific-can-i-ship-it-with-my-python-library
    rm "#{share}/glib-2.0/schemas/gschemas.compiled" unless OS.mac?
  end

  plist_options manual: "pulseaudio"

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
          <string>#{opt_bin}/pulseaudio</string>
          <string>--exit-idle-time=-1</string>
          <string>--verbose</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
