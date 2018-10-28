class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/721/libprelude-3.1.0.tar.gz"
  sha256 "b8fbaaa1f2536bd54a7f69fe905ac84d936435962c8fc9de67b2f2b375c7ac96"
  revision 2
  # tag "linuxbrew"

  bottle do
    sha256 "189967ff2af15f82c5e1ca70ab34e332f8c8c8ce0911f5ccb402baaefa39aba9" => :x86_64_linux
  end

  option "without-ruby", "Build without Ruby bindings"

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "gnutls"
  depends_on "swig" => [:build, :recommended]
  depends_on "perl" => [:build, :optional]
  depends_on "python@2" => [:build, :recommended]
  depends_on "python" => :recommended
  depends_on "valgrind" => [:build, :recommended]
  depends_on "lua" => [:build, :optional]
  depends_on "ruby"

  skip_clean "etc", "lib64", "var", :la

  def install
    ENV["HAVE_CXX"] = "yes"
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-rpath
      --with-pic
    ]

    args << "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}" if build.with? "libgcrypt"
    args << "--with-libgnutls-prefix=#{Formula["gnutls"].opt_prefix}" if build.with? "gnutls"

    %w[swig perl python2 python3 valgrind lua ruby].each do |r|
      args << "--with-#{r}=#{build.with?(r) ? "yes" : "no"}"
    end

    system "./configure", *args
    system "make"
    # Disabled due to https://lists.gnu.org/archive/html/bug-gnulib/2018-05/msg00059.html
    system "make", "check" if OS.mac?
    system "make", "install"
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"libprelude-config --prefix").chomp
    assert_equal version.to_s, shell_output(bin/"libprelude-config --version").chomp
  end
end
