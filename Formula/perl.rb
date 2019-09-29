class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.30.0.tar.gz"
  sha256 "851213c754d98ccff042caa40ba7a796b2cee88c5325f121be5cbb61bbf975f2"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  bottle do
    sha256 "558b5c5408c82ec7e14ea7974b5f1e62ed5a5ed8343506c69b94becfe27e2488" => :catalina
    sha256 "c0d17d9af9a950c65c7ac39f5d5bcdc2932ab281455107a5c55d1eda7d792f0d" => :mojave
    sha256 "8529587433c3bf6985dd92d39808c01d9d421eeef8e25dc5b2921729d253c346" => :high_sierra
    sha256 "086995758ea8f80844c3acb75ac8c177421560b382d22f63d128668f31918b0e" => :sierra
    sha256 "e9dd9851a056caaa2bdea8d1e22136625e7fa66b82c9787c5d8e466456a7b9c3" => :x86_64_linux
  end

  unless OS.mac?
    depends_on "gdbm"
    depends_on "berkeley-db"

    # required for XML::Parser
    depends_on "expat"
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

    args << "-Dusedevel" if build.head?
    # Fix for https://github.com/Linuxbrew/homebrew-core/issues/405
    args << "-Dlocincpth=#{HOMEBREW_PREFIX}/include" if OS.linux?

    system "./Configure", *args

    system "make"
    # On Linux (in travis / docker container), the op/getppid.t fails too, disable the tests:
    # https://rt.perl.org/Public/Bug/Display.html?id=130143
    system "make", "test" if OS.mac?

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
      # Glibc does not provide the xlocale.h file since version 2.26
      # Patch the perl.h file to be able to use perl on newer versions.
      # locale.h includes xlocale.h if the latter one exists
      perl_core = Pathname.new(`#{bin/"perl"} -MConfig -e 'print $Config{archlib}'`)+"CORE"
      inreplace "#{perl_core}/perl.h", "include <xlocale.h>", "include <locale.h>", :audit_result => false

      # CPAN modules installed via the system package manager will not be visible to
      # brewed Perl. As a temporary measure, install critical CPAN modules to ensure
      # they are available. See https://github.com/Linuxbrew/homebrew-core/pull/1064
      ENV.activate_extensions!
      ENV.setup_build_environment(self)
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      system bin/"cpan", "-i", "XML::Parser"
      system bin/"cpan", "-i", "XML::SAX"
    end
  end

  def caveats; <<~EOS
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
