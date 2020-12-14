class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.32.0.tar.xz"
  sha256 "6f436b447cf56d22464f980fac1916e707a040e96d52172984c5d184c09b859b"
  license any_of: ["Artistic-1.0-Perl", "GPL-1.0-or-later"]
  head "https://github.com/perl/perl5.git", branch: "blead"
  revision 1 unless OS.mac?

  livecheck do
    url "https://www.cpan.org/src/"
    regex(/href=.*?perl[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 "7db44dc9609acbada14bd4cf847b26b49f1b3f18693e0870e806741a274c957a" => :big_sur
    sha256 "bb412cbff8e5c80bcecc7141d10c5b34b8bbcf46d05d926805bff68d120d0cf1" => :arm64_big_sur
    sha256 "bc6c97521b6edf723c8ee0742aebb1954b5c8fec81bf2d96861c3f8bcc4e404d" => :catalina
    sha256 "f09b3fefe2175b36e590ee13e7aa84d28ebcbce3ef8e252e24a0aebb752405ab" => :mojave
    sha256 "718a54da6e3b02c33d5230776aaa54eaaac710c09cf412078014c9c50dd0ac51" => :high_sierra
  end

  uses_from_macos "expat"

  unless OS.mac?
    depends_on "gettext"
    depends_on "gdbm"
    depends_on "berkeley-db"
  end

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  patch do
    # Enable build support on macOS 11.x
    # Remove when https://github.com/Perl/perl5/pull/17946 is merged
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/526faca9830646b974f563532fa27a1515e51ca1/perl/version_check.patch"
    sha256 "cff250437f141eb677ec2215a9f2dfcbacba77304dac06499db6c722c9d30b58"
  end

  def install
    ENV.append "LDFLAGS", "-lintl" unless OS.mac?

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
