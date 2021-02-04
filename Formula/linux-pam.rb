class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "http://www.linux-pam.org"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.4.0/Linux-PAM-1.4.0.tar.xz"
  sha256 "cd6d928c51e64139be3bdb38692c68183a509b83d4f2c221024ccd4bcddfd034"
  revision 1
  head "https://github.com/linux-pam/linux-pam.git"

  bottle do
    sha256 x86_64_linux: "26f3fa749b46eb4a489aa258cc2a9d4a9f8cc644fb36894afd942028970cce3a"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libprelude"
  depends_on "libtirpc"
  depends_on :linux

  skip_clean :la, "etc"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --disable-selinux
      --prefix=#{prefix}
      --includedir=#{include}/security
      --oldincludedir=#{include}
      --enable-securedir=#{lib}/security
      --sysconfdir=#{etc}
      --with-xml-catalog=#{etc}/xml/catalog
      --with-libprelude-prefix=#{Formula["libprelude"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    chmod "u=rwxs,g=rx,o=rx", "#{sbin}/unix_chkpwd"
  end

  test do
    File.exist? "#{sbin}/unix_chkpwd"
    assert_match "Usage", shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
