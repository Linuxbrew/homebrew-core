class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "http://www.linux-pam.org"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.4.0/Linux-PAM-1.4.0.tar.xz"
  sha256 "cd6d928c51e64139be3bdb38692c68183a509b83d4f2c221024ccd4bcddfd034"
  revision 1
  head "https://github.com/linux-pam/linux-pam.git"

  bottle do
    sha256 "8a27f4ff10628a7366f0a63480433fa1138c547fbd49343258abb47cd4908e67" => :big_sur
    sha256 "4b32c4d13a178a568d7a8668f0d42c40a02d161fac8ea7b10f5c2e468cbca4a6" => :catalina
    sha256 "c52e7c5c5a92e4e5faf2ab5aa6cb66eeabc943869161bf5c8853b37dbd6a49a3" => :mojave
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
