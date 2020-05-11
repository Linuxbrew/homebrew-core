class Subversion < Formula
  desc "Version control system designed to be a better CVS"
  homepage "https://subversion.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=subversion/subversion-1.13.0.tar.bz2"
  mirror "https://archive.apache.org/dist/subversion/subversion-1.13.0.tar.bz2"
  sha256 "bc50ce2c3faa7b1ae9103c432017df98dfd989c4239f9f8270bb3a314ed9e5bd"
  revision 5

  bottle do
    sha256 "0c131c339c9d452563aeda9dffc0acbe2f75be6d4ab3f8eda3ffdab7b0e06a67" => :catalina
    sha256 "a19ac8763a4d06dd030d6f41cb5b64e15bae68f33b95ebb677040e58d4a1f9f1" => :mojave
    sha256 "a901ee429676a52297443213f234d4b30e21a7c25a660fed21d767bc2fd0a5e1" => :high_sierra
    sha256 "2898a45955cc9120b9b82ad4906bb09f4ac1545dde6c78918e35108a0e3eeb01" => :x86_64_linux
  end

  head do
    url "https://github.com/apache/subversion.git", :branch => "trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "openjdk" => :build
  depends_on "pkg-config" => :build
  depends_on "scons" => :build # For Serf
  depends_on "swig@3" => :build # https://issues.apache.org/jira/browse/SVN-4818
  depends_on "apr"
  depends_on "apr-util"

  # build against Homebrew versions of
  # gettext, lz4, perl, sqlite and utf8proc for consistency
  depends_on "gettext"
  depends_on "lz4"
  depends_on :macos if OS.mac? # Due to Python 2
  # See https://github.com/Homebrew/homebrew-core/issues/53193#issue-600482673
  # Will work with Python 3.8 in subversion 1.14
  depends_on "openssl@1.1" # For Serf
  depends_on "perl"
  depends_on "python@3.8" unless OS.mac?
  depends_on "sqlite"
  depends_on "utf8proc"

  depends_on "libtool" unless OS.mac?

  uses_from_macos "expat"
  uses_from_macos "krb5"
  uses_from_macos "ruby"
  uses_from_macos "zlib"

  resource "serf" do
    url "https://www.apache.org/dyn/closer.lua?path=serf/serf-1.3.9.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2"
    sha256 "549c2d21c577a8a9c0450facb5cca809f26591f048e466552240947bdf7a87cc"
  end

  # Fix #23993 by stripping flags swig can't handle from SWIG_CPPFLAGS
  # Prevent "-arch ppc" from being pulled in from Perl's $Config{ccflags}
  # Prevent linking into a Python Framework
  patch :DATA if OS.mac?

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    serf_prefix = OS.mac? ? libexec/"serf" : prefix

    resource("serf").stage do
      unless OS.mac?
        inreplace "SConstruct" do |s|
          s.gsub! "env.Append(LIBPATH=['$OPENSSL\/lib'])",
          "\\1\nenv.Append(CPPPATH=['$ZLIB\/include'])\nenv.Append(LIBPATH=['$ZLIB/lib'])"
        end
        inreplace "SConstruct" do |s|
          s.gsub! "print 'Warning: Used unknown variables:', ', '.join(unknown.keys())",
          "print('Warning: Used unknown variables:', ', '.join(unknown.keys()))"
          s.gsub! "match = re.search('SERF_MAJOR_VERSION ([0-9]+).*'",
          "match = re.search(b'SERF_MAJOR_VERSION ([0-9]+).*'"
          s.gsub! "'SERF_MINOR_VERSION ([0-9]+).*'",
          "b'SERF_MINOR_VERSION ([0-9]+).*'"
          s.gsub! "'SERF_PATCH_VERSION ([0-9]+)'",
          "b'SERF_PATCH_VERSION ([0-9]+)'"
        end
      end
      # scons ignores our compiler and flags unless explicitly passed
      args = %W[
        PREFIX=#{serf_prefix} GSSAPI=#{Formula["krb5"].opt_prefix} CC=#{ENV.cc}
        CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}
        OPENSSL=#{Formula["openssl@1.1"].opt_prefix}
        APR=#{Formula["apr"].opt_prefix}
        APU=#{Formula["apr-util"].opt_prefix}
        ZLIB=#{Formula["zlib"].opt_prefix}
      ]
      system "scons", *args
      system "scons", "install"
    end

    # Use existing system zlib
    # Use dep-provided other libraries
    # Don't mess with Apache modules (since we're not sudo)
    zlib = OS.mac? ? "#{MacOS.sdk_path_if_needed}/usr" : Formula["zlib"].opt_prefix
    ruby = OS.mac? ? "/usr/bin/ruby" : "#{Formula["ruby"].opt_bin}/ruby"
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --enable-optimize
      --disable-mod-activation
      --disable-plaintext-password-storage
      --with-apr-util=#{Formula["apr-util"].opt_prefix}
      --with-apr=#{Formula["apr"].opt_prefix}
      --with-apxs=no
      --with-jdk=#{Formula["openjdk"].opt_prefix}
      --with-ruby-sitedir=#{lib}/ruby
      --with-serf=#{serf_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
      --with-zlib=#{zlib}
      --without-apache-libexecdir
      --without-berkeley-db
      --without-gpg-agent
      --enable-javahl
      --without-jikes
      RUBY=#{ruby}
    ]

    # The system Python is built with llvm-gcc, so we override this
    # variable to prevent failures due to incompatible CFLAGS
    ENV["ac_cv_python_compile"] = ENV.cc

    inreplace "Makefile.in",
              "toolsdir = @bindir@/svn-tools",
              "toolsdir = @libexecdir@/svn-tools"

    # regenerate configure file as we patched `build/ac-macros/swig.m4`
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    # Fix ld: cannot find -lsvn_delta-1
    ENV.deparallelize { system "make", "install" }
    bash_completion.install "tools/client-side/bash_completion" => "subversion"

    system "make", "tools"
    system "make", "install-tools"

    system "make", "swig-py"
    system "make", "install-swig-py"
    (lib/"python2.7/site-packages").install_symlink Dir["#{lib}/svn-python/*"]

    # Java and Perl support don't build correctly in parallel:
    # https://github.com/Homebrew/homebrew/issues/20415
    ENV.deparallelize
    system "make", "javahl"
    system "make", "install-javahl"

    archlib = Utils.popen_read("perl -MConfig -e 'print $Config{archlib}'")
    perl_core = Pathname.new(archlib)/"CORE"
    onoe "'#{perl_core}' does not exist" unless perl_core.exist?

    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "SWIG_PL_INCLUDES",
          "$(SWIG_INCLUDES) -arch #{MacOS.preferred_arch} -g -pipe -fno-common " \
          "-DPERL_DARWIN -fno-strict-aliasing -I#{HOMEBREW_PREFIX}/include -I#{perl_core}"
      end
    end
    system "make", "swig-pl"
    system "make", "install-swig-pl"

    # This is only created when building against system Perl, but it isn't
    # purged by Homebrew's post-install cleaner because that doesn't check
    # "Library" directories. It is however pointless to keep around as it
    # only contains the perllocal.pod installation file.
    rm_rf prefix/"Library/Perl"
  end

  def caveats
    <<~EOS
      svntools have been installed to:
        #{opt_libexec}

      The perl bindings are located in various subdirectories of:
        #{opt_lib}/perl5

      You may need to link the Java bindings into the Java Extensions folder:
        sudo mkdir -p /Library/Java/Extensions
        sudo ln -s #{HOMEBREW_PREFIX}/lib/libsvnjavahl-1.dylib /Library/Java/Extensions/libsvnjavahl-1.dylib
    EOS
  end

  test do
    system "#{bin}/svnadmin", "create", "test"
    system "#{bin}/svnadmin", "verify", "test"
    system "perl", "-e", "use SVN::Client; new SVN::Client()"
  end
end

__END__
diff --git a/subversion/bindings/swig/perl/native/Makefile.PL.in b/subversion/bindings/swig/perl/native/Makefile.PL.in
index a60430b..bd9b017 100644
--- a/subversion/bindings/swig/perl/native/Makefile.PL.in
+++ b/subversion/bindings/swig/perl/native/Makefile.PL.in
@@ -76,10 +76,13 @@ my $apr_ldflags = '@SVN_APR_LIBS@'

 chomp $apr_shlib_path_var;

+my $config_ccflags = $Config{ccflags};
+$config_ccflags =~ s/-arch\s+\S+//g;
+
 my %config = (
     ABSTRACT => 'Perl bindings for Subversion',
     DEFINE => $cppflags,
-    CCFLAGS => join(' ', $cflags, $Config{ccflags}),
+    CCFLAGS => join(' ', $cflags, $config_ccflags),
     INC  => join(' ', $includes, $cppflags,
                  " -I$swig_srcdir/perl/libsvn_swig_perl",
                  " -I$svnlib_srcdir/include",

diff --git a/build/get-py-info.py b/build/get-py-info.py
index 29a6c0a..dd1a5a8 100644
--- a/build/get-py-info.py
+++ b/build/get-py-info.py
@@ -83,7 +83,7 @@ def link_options():
   options = sysconfig.get_config_var('LDSHARED').split()
   fwdir = sysconfig.get_config_var('PYTHONFRAMEWORKDIR')

-  if fwdir and fwdir != "no-framework":
+  if fwdir and fwdir != "no-framework" and sys.platform != 'darwin':

     # Setup the framework prefix
     fwprefix = sysconfig.get_config_var('PYTHONFRAMEWORKPREFIX')
