class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.32.1.tar.xz"
  sha256 "57cc47c735c8300a8ce2fa0643507b44c4ae59012bfdad0121313db639e02309"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "94989cfa38487dfbea5d430da2e4e85734d79b6125020992a5009624628899f1"
    sha256 big_sur:       "846c28c0b3ae4d63fb82feef77832b37f198a5669f4fb58a9a4cd081aa9c1e27"
    sha256 catalina:      "dce1838f66ce3929a58c1a68f351c98f7f2176b41d624e3cfc7bd8ec72d8cf90"
    sha256 mojave:        "45de452aa689c422e320ea35fa040a9cc0c6640c2a3b1dff9cabff3f4f17b490"
    sha256 x86_64_linux:  "e1b506ab35bdd27e12bce3e3adb86e8121eb21166abfe07e6e8258f3041e331b"
  end

  uses_from_macos "expat"

  unless OS.mac?
    depends_on "gdbm"
    depends_on "berkeley-db"
  end

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]
    args << "-Dsed=/usr/bin/sed" if OS.mac?

    args << "-Dusedevel" if build.head?
    # Fix for https://github.com/Linuxbrew/homebrew-core/issues/405
    args << "-Dlocincpth=#{HOMEBREW_PREFIX}/include" if OS.linux?

    system "./Configure", *args

    system "make"
    system "make", "install"

    # expose libperl.so to ensure we aren't using a brewed executable
    # but a system library
    if OS.linux?
      perl_core = Pathname.new(`#{bin/"perl"} -MConfig -e 'print $Config{archlib}'`)+"CORE"
      lib.install_symlink perl_core/"libperl.so"
    end
  end

  def post_install
    unless OS.mac?
      perl_core = Pathname.new(`#{bin/"perl"} -MConfig -e 'print $Config{archlib}'`)+"CORE"
      if File.readlines("#{perl_core}/perl.h").grep(/include <xlocale.h>/).any? &&
         (OS::Linux::Glibc.system_version >= "2.26" ||
         (Formula["glibc"].any_version_installed? && Formula["glibc"].version >= "2.26"))
        # Glibc does not provide the xlocale.h file since version 2.26
        # Patch the perl.h file to be able to use perl on newer versions.
        # locale.h includes xlocale.h if the latter one exists
        inreplace "#{perl_core}/perl.h", "include <xlocale.h>", "include <locale.h>"
      end

      # CPAN modules installed via the system package manager will not be visible to
      # brewed Perl. As a temporary measure, install critical CPAN modules to ensure
      # they are available. See https://github.com/Linuxbrew/homebrew-core/pull/1064
      ENV.activate_extensions!
      ENV.setup_build_environment(formula: self)
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      system bin/"cpan", "-i", "XML::Parser"
      system bin/"cpan", "-i", "XML::SAX"
    end
  end

  def caveats
    <<~EOS
      By default non-brewed cpan modules are installed to the Cellar. If you wish
      for your modules to persist across updates we recommend using `local::lib`.

      You can set that up like this:
        PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
        echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
    EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
