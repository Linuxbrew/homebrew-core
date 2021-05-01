class LinuxPam < Formula
  desc "Pluggable Authentication Modules for Linux"
  homepage "http://www.linux-pam.org"
  url "https://github.com/linux-pam/linux-pam/releases/download/v1.5.1/Linux-PAM-1.5.1.tar.xz"
  sha256 "201d40730b1135b1b3cdea09f2c28ac634d73181ccd0172ceddee3649c5792fc"
  license any_of: ["BSD-3-Clause", "GPL-1.0-only"]
  head "https://github.com/linux-pam/linux-pam.git"

  bottle do
    sha256 x86_64_linux: "465098b7da72f978dfece7fa8a12168b4730be8427d3cd9e6f55beafd66fa1dc"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "libprelude"
  depends_on "libtirpc"
  depends_on :linux

  skip_clean :la

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

  test do
    assert_match "Usage: #{sbin}/mkhomedir_helper <username>",
                 shell_output("#{sbin}/mkhomedir_helper 2>&1", 14)
  end
end
