class I686ElfBinutils < Formula
  desc "GNU Binutils for i686-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.1.tar.xz"
  sha256 "e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_big_sur: "668698ca23b0707a9faa869d3d20160ce402fde86b7d38e9dd762b73da95f656"
    sha256 big_sur:       "b4b69b92b71ff9fa78a45e1f5c6082f68b427a40d6fd1e6a03d3e6fcad8106ba"
    sha256 catalina:      "806493e1e1060fc49682d2414d59d866c2850233ee19edc31354e30627deb2b6"
    sha256 mojave:        "55bc73ee9368c4cea0af5ed9262facc48745425c8c04d06bf579a083d512f978"
    sha256 x86_64_linux:  "5d3614c98968d27b0bee75621d5eb0bc29d2b862b81428f5e2be934675409d8b" # linuxbrew-core
  end

  def install
    target = "i686-elf"
    system "./configure", "--target=#{target}",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~EOS
      .section .data
      .section .text
      .globl _start
      _start:
          movl $1, %eax
          movl $4, %ebx
          int $0x80
    EOS
    system "#{bin}/i686-elf-as", "--32", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-i386",
      shell_output("#{bin}/i686-elf-objdump -a test-s.o")
  end
end
