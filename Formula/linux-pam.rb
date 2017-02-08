class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "http://www.linux-pam.org"
  url "http://linux-pam.org/library/Linux-PAM-1.3.0.tar.bz2"
  sha256 "241aed1ef522f66ed672719ecf2205ec513fd0075ed80cda8e086a5b1a01d1bb"
  # tag "linuxbrew"

  depends_on "pkg-config" => :build
  depends_on "libprelude" => :recommended
  depends_on "berkeley-db"

  skip_clean :la, "etc"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --includedir=#{include}/security
      --oldincludedir=#{include}
      --enable-securedir=#{lib}/security
      --sysconfdir=#{etc}
      --with-xml-catalog=#{etc}/xml/catalog
    ]
    args << "--with-libprelude-prefix=#{Formula["libprelude"].opt_prefix}" if build.with? "libprelude"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  def post_install
    chmod "u=rwxs,g=rx,o=rx", "#{sbin}/unix_chkpwd"
  end

  test do
    File.exist? "#{sbin}/unix_chkpwd"
    assert_match "Usage", shell_output("#{sbin}/mkhomedir_helper")
  end
end
