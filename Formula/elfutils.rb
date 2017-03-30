class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects."
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.168/elfutils-0.168.tar.bz2"
  sha256 "b88d07893ba1373c7dd69a7855974706d05377766568a7d9002706d5de72c276"
  # tag "linuxbrew"

  bottle do
    sha256 "99c141bcce532d5f70a3754028faf3c6c93ed3e6c6861ad633173ad334afef5e" => :x86_64_linux
  end

  option "with-valgrind", "Run tests with valgrind"

  depends_on "xz"
  depends_on "bzip2" unless OS.mac?
  depends_on "zlib" unless OS.mac?
  depends_on "valgrind" => [:build, :optional]

  conflicts_with "libelf",  :because => "both install `libelf.a` library"

  fails_with :clang do
    build 700
    cause "gcc with GNU99 support required"
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--program-prefix=elfutils-",
      "--prefix=#{prefix}",
      *("--enable-valgrind" if build.with? "valgrind")
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    output = `#{bin}/elfutils-nm #{bin}/elfutils-nm`
    assert_match /elf_kind/, output
  end
end
