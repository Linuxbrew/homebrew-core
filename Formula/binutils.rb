class Binutils < Formula
  desc "FSF Binutils for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.28.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.28.tar.gz"
  sha256 "cd717966fc761d840d451dbd58d44e1e5b92949d2073d75b73fccb476d772fcf"

  bottle do
    cellar :any if OS.linux?
    sha256 "8da3588c5cb51ae12e73ab975060d33629435c7951f56db956abf947d7354fda" => :sierra
    sha256 "d77015966ffc11235237a2601ca4f5c20c13efc4725137dd6c6861a2ef047fc8" => :el_capitan
    sha256 "8097f28ad68ddd83983742a4840aa4cd858500a5f264fd2dc487c66a06c873c5" => :yosemite
    sha256 "53bfa9e8d96ca5f7e5023e674ff997b34ca24cd28ce5bf081ecca15e638be544" => :x86_64_linux
  end

  # No --default-names option as it interferes with Homebrew builds.
  option "with-default-names", "Do not prepend 'g' to the binary" if OS.linux?
  option "without-gold", "Do not build gold" if OS.linux?

  depends_on "zlib" => :recommended unless OS.mac?

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          ("--program-prefix=g" if build.without? "default-names"),
                          ("--with-sysroot=/" if OS.linux?),
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          ("--enable-gold" if OS.linux? && build.with?("gold")),
                          ("--enable-plugins" if OS.linux?),
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold" if OS.linux?
  end

  test do
    # Better to check with?("default-names"), but that doesn't work.
    nm = build.with?("default-names") ? "nm" : "gnm"
    assert_match "main", shell_output("#{bin}/#{nm} #{bin}/#{nm}")
  end
end
