class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/1172/libprelude-5.1.0.tar.gz"
  sha256 "a5fa3ca1e428291afe4bb5095f01c05fd0d9ebd517a0ce3d07ca9977abcf41fa"
  # tag "linux"

  bottle do
  end

  depends_on "libtool" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build
  depends_on "ruby" => :build
  depends_on "swig" => :build
  depends_on "valgrind" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "lua"

  def install
    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-rpath
      --with-pic
      --with-python3
      --with-valgrind
      --with-lua
      --with-ruby
      --with-perl
      --with-swig
      --with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}
      --with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"libprelude-config --prefix").chomp
    assert_equal version.to_s, shell_output(bin/"libprelude-config --version").chomp
  end
end
