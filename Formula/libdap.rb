class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.19.0.tar.gz"
  sha256 "59c384c2da01104a4ef37f010f3bcf5d46e85e30fcfc942c9181e17128f168a5"

  bottle do
    sha256 "110ec83b0705a4c30e65e460690a7026498a2ce128dd20b4e013539e3db17a91" => :sierra
    sha256 "9c09de6a72e425c1b4ba4e0587b2e18e846ea72808b7938f974641d560ca71ee" => :el_capitan
    sha256 "f1d677f7175cead9f608b9f32352cd47ae19c0761dd7217254a255d0968e43cc" => :yosemite
    sha256 "70b828b88dadd37872e8e2261a9d6b388de56a91cb6c70b70e673cc497d2507a" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option "without-test", "Skip build-time tests (Not recommended)"

  # error: 'max_align_t' has a previous declaration when using gcc 4.8
  fails_with :gcc => "4.8" unless OS.mac?

  depends_on "pkg-config" => :build
  depends_on "bison" => :build
  depends_on "libxml2"
  depends_on "openssl"
  unless OS.mac?
    depends_on "curl"
    depends_on "flex" => :build
    depends_on "util-linux" # for libuuid
  end

  needs :cxx11 if MacOS.version < :mavericks

  def install
    # Otherwise, "make check" fails
    ENV.cxx11 if MacOS.version < :mavericks

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    # Let's try removing this for OS X > 10.6; old note follows:
    # __Always pass the curl prefix!__
    # Otherwise, configure will fall back to pkg-config and on Leopard
    # and Snow Leopard, the libcurl.pc file that ships with the system
    # is seriously broken---too many arch flags. This will be carried
    # over to `dap-config` and from there the contamination will spread.
    args << "--with-curl=/usr" if OS.mac? && MacOS.version <= :snow_leopard

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
