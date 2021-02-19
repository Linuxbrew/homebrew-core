class Elfutils < Formula
  desc "Libraries and utilities for handling ELF objects"
  homepage "https://fedorahosted.org/elfutils/"
  url "https://sourceware.org/elfutils/ftp/0.177/elfutils-0.177.tar.bz2"
  sha256 "fa489deccbcae7d8c920f60d85906124c1989c591196d90e0fd668e3dc05042e"

  bottle do
    sha256 x86_64_linux: "8297b1cab94e012e52507b9b733a53599c5d5f928aa6cbe866de9dfb3e5e5e64"
  end

  depends_on "m4" => :build
  depends_on "bzip2"
  depends_on :linux
  depends_on "xz"
  depends_on "zlib"

  conflicts_with "libelf", because: "both install `libelf.a` library"

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
      "--prefix=#{prefix}"
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
      dwarf-die-addr-die
      elfclassify
      exprlocs-self
      get-units-invalid
      get-units-split
      readelf-self
      strip-g
      strip-reloc
      strip-strmerge
      unit-info
      varlocs-self
    ]
    skip_tests.each do |test|
      file = "tests/run-#{test}.sh"
      rm_f file
      Pathname(file).write("exit 77", perm: 0755)
    end

    system "make", "check"
    system "make", "install"
  end

  test do
    output = `#{bin}/elfutils-nm #{bin}/elfutils-nm`
    assert_match "elf_kind", output
  end
end
