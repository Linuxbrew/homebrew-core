class Git < Formula
  desc "Distributed revision control system"
  homepage "https://git-scm.com"
  url "https://www.kernel.org/pub/software/scm/git/git-2.9.0.tar.xz"
  sha256 "f41fa97949948fbf49af94a43d779e072a5452c6b5039d86ffa41ebab747b409"

  head "https://github.com/git/git.git", :shallow => false

  bottle do
    sha256 "5d3586ec7834418aec22526a508b0e4af77ef353072a13e46ff4324b55f18c1e" => :el_capitan
    sha256 "769118df0709a5e0eb3e00b16f98f558b4e627b38efa51f63a9ca9aa6e3d19a6" => :yosemite
    sha256 "6f8c793e71d2bd28855a270e3bf8e06310a113c638e32ddd6dedc8206cc9ad4c" => :mavericks
    sha256 "a409aa2a71da1b044ed950b856376988cdf7ff6f052a49944709b50f230d268f" => :x86_64_linux
  end

  option "with-blk-sha1", "Compile with the block-optimized SHA1 implementation"
  option "without-completions", "Disable bash/zsh completions from 'contrib' directory"
  if OS.mac?
    option "with-brewed-openssl", "Build with Homebrew OpenSSL instead of the system version"
    option "with-brewed-curl", "Use Homebrew's version of cURL library"
  else
    option "without-brewed-openssl", "Build with the system's OpenSSL library instead of Homebrew's"
    option "without-brewed-curl", "Build with the system's cURL library instead of Homebrew's"
  end
  option "with-brewed-svn", "Use Homebrew's version of SVN"
  option "with-persistent-https", "Build git-remote-persistent-https from 'contrib' directory"

  depends_on "pcre" => :optional
  depends_on "gettext" => :optional
  depends_on "openssl" if build.with? "brewed-openssl"
  depends_on "curl" if build.with? "brewed-curl"
  depends_on "go" => :build if build.with? "persistent-https"
  depends_on "expat" unless OS.mac?
  depends_on "homebrew/dupes/tcl-tk" => :optional unless OS.mac?

  # Trigger an install of swig before subversion, as the "swig" doesn't get pulled in otherwise
  # See https://github.com/Homebrew/homebrew/issues/34554
  if build.with? "brewed-svn"
    depends_on "swig"
    depends_on "subversion" => "with-perl"
  end

  resource "html" do
    url "https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.9.0.tar.xz"
    sha256 "664dc1aa20966a91cf6b90d282bb5f93b4e4c831a32a0791f43218389ce3b955"
  end

  resource "man" do
    url "https://www.kernel.org/pub/software/scm/git/git-manpages-2.9.0.tar.xz"
    sha256 "dc85c1afa923fd709d651a49d0a720d50a3c248cb16c6c09517cceae88fe8445"
  end

  def install
    # If these things are installed, tell Git build system to not use them
    ENV["NO_FINK"] = "1"
    ENV["NO_DARWIN_PORTS"] = "1"
    ENV["V"] = "1" # build verbosely
    ENV["NO_R_TO_GCC_LINKER"] = "1" # pass arguments to LD correctly
    ENV["PYTHON_PATH"] = which "python"
    ENV["PERL_PATH"] = which "perl"

    # Support Tcl versions before "lime" color name was introduced
    # https://github.com/Homebrew/homebrew-core/issues/115
    # https://www.mail-archive.com/git%40vger.kernel.org/msg92017.html
    inreplace "gitk-git/gitk", "lime", '"#99FF00"'

    perl_version = /\d\.\d+/.match(`perl --version`)

    if build.with? "brewed-svn"
      ENV["PERLLIB_EXTRA"] = %W[
        #{Formula["subversion"].opt_prefix}/lib/perl5/site_perl
        #{Formula["subversion"].opt_prefix}/Library/Perl/#{perl_version}/darwin-thread-multi-2level
      ].join(":")
    elsif MacOS.version >= :mavericks
      ENV["PERLLIB_EXTRA"] = %W[
        #{MacOS.active_developer_dir}
        /Library/Developer/CommandLineTools
        /Applications/Xcode.app/Contents/Developer
      ].uniq.map do |p|
        "#{p}/Library/Perl/#{perl_version}/darwin-thread-multi-2level"
      end.join(":")
    end

    unless quiet_system ENV["PERL_PATH"], "-e", "use ExtUtils::MakeMaker"
      ENV["NO_PERL_MAKEMAKER"] = "1"
    end

    ENV["BLK_SHA1"] = "1" if build.with? "blk-sha1"

    if build.with? "pcre"
      ENV["USE_LIBPCRE"] = "1"
      ENV["LIBPCREDIR"] = Formula["pcre"].opt_prefix
    end

    ENV["NO_GETTEXT"] = "1" if build.without? "gettext"

    args = %W[
      prefix=#{prefix}
      sysconfdir=#{etc}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      LDFLAGS=#{ENV.ldflags}
    ]
    args << "NO_OPENSSL=1" << "APPLE_COMMON_CRYPTO=1" if build.without? "brewed-openssl"
    args << "NO_TCLTK=1" if build.without? "tcl-tk"

    system "make", "install", *args

    # Install the OS X keychain credential helper
    cd "contrib/credential/osxkeychain" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-credential-osxkeychain"
      system "make", "clean"
    end if OS.mac?

    # Install git-subtree
    cd "contrib/subtree" do
      system "make", "CC=#{ENV.cc}",
                     "CFLAGS=#{ENV.cflags}",
                     "LDFLAGS=#{ENV.ldflags}"
      bin.install "git-subtree"
    end

    if build.with? "persistent-https"
      cd "contrib/persistent-https" do
        system "make"
        bin.install "git-remote-persistent-http",
                    "git-remote-persistent-https",
                    "git-remote-persistent-https--proxy"
      end
    end

    if build.with? "completions"
      # install the completion script first because it is inside "contrib"
      bash_completion.install "contrib/completion/git-completion.bash"
      bash_completion.install "contrib/completion/git-prompt.sh"

      zsh_completion.install "contrib/completion/git-completion.zsh" => "_git"
      cp "#{bash_completion}/git-completion.bash", zsh_completion
    end

    elisp.install Dir["contrib/emacs/*.el"]
    (share+"git-core").install "contrib"

    # We could build the manpages ourselves, but the build process depends
    # on many other packages, and is somewhat crazy, this way is easier.
    man.install resource("man")
    (share+"doc/git-doc").install resource("html")

    # Make html docs world-readable
    chmod 0644, Dir["#{share}/doc/git-doc/**/*.{html,txt}"]
    chmod 0755, Dir["#{share}/doc/git-doc/{RelNotes,howto,technical}"]

    # To avoid this feature hooking into the system OpenSSL, remove it.
    # If you need it, install git --with-brewed-openssl.
    rm "#{libexec}/git-core/git-imap-send" if build.without? "brewed-openssl"

    pod = Dir[lib/"*/*/perllocal.pod"][0]
    if pod != nil
      # Remove perllocal.pod, which conflicts with the perl formula.
      # I don't know why this issue doesn't affect Mac.
      rm_r Pathname.new(pod).dirname.dirname
    end
  end

  def caveats; <<-EOS.undent
    The OS X keychain credential helper has been installed to:
      #{HOMEBREW_PREFIX}/bin/git-credential-osxkeychain

    The "contrib" directory has been installed to:
      #{HOMEBREW_PREFIX}/share/git-core/contrib
    EOS
  end

  test do
    assert_match(/^git version .*$/, shell_output("#{bin}/git --version").strip)
    system "#{bin}/git init"
    system "#{bin}/git status"
    system "#{bin}/git config user.email \"you@example.com\""
    system "#{bin}/git config user.name \"Your Name\""
    touch "foo"
    system "#{bin}/git add foo"
    system "#{bin}/git commit -m foo"
    assert_match(/foo/, shell_output("#{bin}/git log --oneline"))
  end
end
