class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/1395/libprelude-5.2.0.tar.gz"
  sha256 "187e025a5d51219810123575b32aa0b40037709a073a775bc3e5a65aa6d6a66e"

  bottle do
    sha256 x86_64_linux: "cb1b9bfee9be1ab5512a2c6fa8b67726c36b851ea713a265b35376b68c6e6e87"
  end

  depends_on "libtool" => :build
  depends_on "perl" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "ruby@2.6" => :build
  depends_on "swig" => :build
  depends_on "valgrind" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on :linux
  depends_on "lua"

  def install
    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-rpath
      --with-pic
      --with-python3
      --without-python2
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
