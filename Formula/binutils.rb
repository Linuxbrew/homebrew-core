class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"

  bottle do
    cellar :any # manually added
    sha256 "a3ed5e2bf0cd0823c5140a6bf44d13f32fbc63a67a4e6d239e1c391518432bd7" => :high_sierra
    sha256 "a815d5c60302a1e71c0970d86769931abd5e985f8d420cfd527aa495930cd393" => :sierra
    sha256 "7c693e68ebfcd654fd781480e68469e8f5af93c7397754a8caae1937322feb8f" => :el_capitan
    sha256 "99698e2b25a672056e8969f0b1a82f9c0a7e19f8cf09cc5ac1710c56d6e72d46" => :x86_64_linux # glibc 2.12
  end

  # No --default-names option as it interferes with Homebrew builds.
  option "without-gold", "Do not build the gold linker" if OS.linux?

  depends_on "zlib" => :recommended unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--program-prefix=g" if OS.mac?),
                          ("--with-sysroot=/" if OS.linux?),
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          ("--enable-gold" if build.with? "gold"),
                          ("--enable-plugins" if OS.linux?),
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold" if build.with? "gold"

    # Reduce the size of the bottle.
    system "strip", *Dir[bin/"*", lib/"*.a"] unless OS.mac?
  end

  test do
    size = OS.mac? ? "gsize" : "size"
    assert_match "text", shell_output("#{bin}/#{size} #{bin}/#{size}")
  end
end
