class X8664ElfGcc < Formula
  desc "The GNU compiler collection for x86_64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-10.1.0/gcc-10.1.0.tar.xz"
  sha256 "b6898a23844b656f1b68691c5c012036c2e694ac4b53a8918d4712ad876e7ea2"

  bottle do
    sha256 "bb2b2a5e091f618b77a7900a8fdc6ea2d7a3591dc7245e417a53d15c9d102e73" => :catalina
    sha256 "831ecfd46bd6537d894cfa9fc8aa3149e04c1fe9b8b0a7a60851cd87cf3608c2" => :mojave
    sha256 "5eccdd282ba40dfc4089244dd576b56b5ddda35160021e542a49374487c34d18" => :high_sierra
  end

  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "x86_64-elf-binutils"

  def install
    mkdir "x86_64-elf-gcc-build" do
      system "../configure", "--target=x86_64-elf",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/x86_64-elf-gcc",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-as",
                             "--with-ld=#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-ld",
                             "--enable-languages=c,c++",
                             "SED=/usr/bin/sed"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/x86_64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-x86-64",
      shell_output("#{Formula["x86_64-elf-binutils"].bin}/x86_64-elf-objdump -a test-c.o")
  end
end
