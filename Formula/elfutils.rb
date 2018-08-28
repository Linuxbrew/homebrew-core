class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.168/elfutils-0.168.tar.bz2"
  sha256 "b88d07893ba1373c7dd69a7855974706d05377766568a7d9002706d5de72c276"
  # tag "linuxbrew"

  bottle do
    sha256 "669e97f7421f27c39bc82ebd0b10d80a9643f5aadf4a029f2ee3accb867431ba" => :x86_64_linux # glibc 2.19
  end

  option "with-valgrind", "Run tests with valgrind"

  depends_on "xz"
  depends_on "valgrind" => [:build, :optional]
  unless OS.mac?
    depends_on "m4" => :build
    depends_on "bzip2"
    depends_on "zlib"
  end

  conflicts_with "libelf", :because => "both install `libelf.a` library"

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

    # Some tests in elfutils require that the package
    # is built with `-g` flag which if filtered out
    # by the superenv. Instead of hacking around to
    # re-enable the flag for elfutils, we disable the
    # tests that require it.
    skip_tests = %w[
      backtrace-data
      backtrace-dwarf
      backtrace-native-core
      backtrace-native
      deleted
      disasm-x86
      readelf-self
      strip-reloc
      strip-strmerge
    ]
    skip_tests.each do |test|
      file = "tests/run-#{test}.sh"
      rm_f file
      Pathname(file).write("exit 77", :perm => 0755)
    end

    system "make", "check"
    system "make", "install"
  end

  test do
    output = `#{bin}/elfutils-nm #{bin}/elfutils-nm`
    assert_match /elf_kind/, output
  end
end
