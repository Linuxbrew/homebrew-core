class Libprelude < Formula
  desc "Universal Security Information & Event Management (SIEM) system"
  homepage "https://www.prelude-siem.org/"
  url "https://www.prelude-siem.org/attachments/download/721/libprelude-3.1.0.tar.gz"
  sha256 "b8fbaaa1f2536bd54a7f69fe905ac84d936435962c8fc9de67b2f2b375c7ac96"

  depends_on "pkg-config" => :build
  depends_on "glibc"
  depends_on "gmp"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libgpg-error" # optional / recommended ?
  depends_on "libtasn1" # optional / recommended ?
  depends_on "libidn" # optional / recommended ?
  depends_on "nettle" # optional / recommended ?
  depends_on "libtool"
  depends_on "swig" => :recommended
  depends_on "bison" => :recommended
  depends_on "flex" => :recommended
  depends_on "perl" => :optional
  depends_on :python => :optional
  depends_on "python3" => :optional

  skip_clean "etc", "lib64", "var", :la

  def install
    ENV["CXX"] = "gcc" # CXX has to be set to "gcc"
    system "./configure"
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--without-lua"

    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    #
  end
end
