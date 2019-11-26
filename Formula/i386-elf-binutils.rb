# i386-elf-binutils: Build a bottle for Linux
class I386ElfBinutils < Formula
  desc "FSF Binutils for i386-elf cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.33.1.tar.gz"
  sha256 "98aba5f673280451a09df3a8d8eddb3aa0c505ac183f1e2f9d00c67aa04c6f7d"

  bottle do
    sha256 "d079ddd99730c921a818fcc4a81066170dd22f23896e218d84b4491362b30032" => :catalina
    sha256 "e510d350f717f7bd32523f51d7f3c5860ce501f029882515c8c7c7e530b7325f" => :mojave
    sha256 "101befd59a8c93c45213df8f2b8166f3804dc10fa16af7f79d6af3892028fc05" => :high_sierra
  end

  def install
    system "./configure", "--target=i386-elf",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/i386-elf-c++filt _Z1fv")
  end
end
