class Rpm < Formula
  desc "Standard unix software packaging tool"
  homepage "https://rpm.org/"
  url "http://ftp.rpm.org/releases/rpm-4.15.x/rpm-4.15.1.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/rpm/releases/rpm-4.15.x/rpm-4.15.1.tar.bz2"
  sha256 "ddef45f9601cd12042edfc9b6e37efcca32814e1e0f4bb8682d08144a3e2d230"
  revision 2
  version_scheme 1

  livecheck do
    url "https://github.com/rpm-software-management/rpm.git"
    regex(/rpm[._-]v?(\d+(?:\.\d+)+)-release/i)
  end

  bottle do
    sha256 "0ab53d077ad1a661161e45dc2af8c7a3767808d3efa14e736346d2001d8bd002" => :big_sur
    sha256 "b8ff31d0e3a8404442c6ab8cab9d6970f53960cb58002a812e1fde9fc0bdc47c" => :catalina
    sha256 "84f9e5185d8aa8a711ec5065380fab393eb6288b470d0f8af68affc9727304c0" => :mojave
  end

  depends_on "berkeley-db"
  depends_on "gettext"
  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "libomp"
  depends_on "lua"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "popt"
  depends_on "xz"
  depends_on "zstd"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["lua"].opt_libexec/"lib/pkgconfig"
    ENV.append "CPPFLAGS", "-I#{Formula["lua"].opt_include}/lua"
    ENV.append "LDFLAGS", "-lomp"

    # only rpm should go into HOMEBREW_CELLAR, not rpms built
    inreplace ["macros.in", "platform.in"], "@prefix@", HOMEBREW_PREFIX

    # ensure that pkg-config binary is found for dep generators
    inreplace "scripts/pkgconfigdeps.sh",
              "/usr/bin/pkg-config", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sharedstatedir=#{var}/lib",
                          "--sysconfdir=#{etc}",
                          "--with-path-magic=#{HOMEBREW_PREFIX}/share/misc/magic",
                          "--enable-nls",
                          "--disable-plugins",
                          "--with-external-db",
                          "--with-crypto=openssl",
                          "--without-apidocs",
                          "--with-vendor=homebrew",
                          # Don't allow superenv shims to be saved into lib/rpm/macros
                          "__MAKE=/usr/bin/make",
                          "__SED=/usr/bin/sed",
                          "__GIT=/usr/bin/git",
                          "__LD=/usr/bin/ld"
    system "make", "install"
  end

  def post_install
    (var/"lib/rpm").mkpath

    if OS.mac?
      # Attempt to fix expected location of GPG to a sane default.
      inreplace lib/"rpm/macros", "/usr/bin/gpg2", HOMEBREW_PREFIX/"bin/gpg"
    end
  end

  def test_spec
    <<~EOS
      Summary:   Test package
      Name:      test
      Version:   1.0
      Release:   1
      License:   Public Domain
      Group:     Development/Tools
      BuildArch: noarch

      %description
      Trivial test package

      %prep
      %build
      %install
      mkdir -p $RPM_BUILD_ROOT/tmp
      touch $RPM_BUILD_ROOT/tmp/test

      %files
      /tmp/test

      %changelog

    EOS
  end

  def rpmdir(macro)
    Pathname.new(`#{bin}/rpm --eval #{macro}`.chomp)
  end

  test do
    (testpath/"rpmbuild").mkpath

    (testpath/".rpmmacros").write <<~EOS
      %_topdir		#{testpath}/rpmbuild
      %_tmppath		%\{_topdir}/tmp
    EOS

    system "#{bin}/rpm", "-vv", "-qa", "--dbpath=#{testpath}/var/lib/rpm"
    assert_predicate testpath/"var/lib/rpm/Packages", :exist?,
                     "Failed to create 'Packages' file!"
    rpmdir("%_builddir").mkpath
    specfile = rpmdir("%_specdir")+"test.spec"
    specfile.write(test_spec)
    system "#{bin}/rpmbuild", "-ba", specfile
    assert_predicate rpmdir("%_srcrpmdir")/"test-1.0-1.src.rpm", :exist?
    assert_predicate rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm", :exist?
    system "#{bin}/rpm", "-qpi", "--dbpath=#{testpath}/var/lib/rpm",
                         rpmdir("%_rpmdir")/"noarch/test-1.0-1.noarch.rpm"
  end
end
