# diffutils: Build a bottle for Linuxbrew
class Diffutils < Formula
  desc "File comparison utilities"
  homepage "https://www.gnu.org/s/diffutils/"
  url "https://ftp.gnu.org/gnu/diffutils/diffutils-3.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/diffutils/diffutils-3.6.tar.xz"
  sha256 "d621e8bdd4b573918c8145f7ae61817d1be9deb4c8d2328a65cea8e11d783bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "e25b8b0c5e7cde495e36ab63e7e6d682dbe8039f0de292b85ce7f19b94ea1e41" => :sierra
    sha256 "b333804e8f86f2d99ac44c5cee06a3f615b8e69de0b68090792fd48436e8463a" => :el_capitan
    sha256 "e5c66fefaabbcbf9149128538bde4935be2bbc60849721c90546b21bca932399" => :yosemite
    sha256 "cec13e7a735d8832c242287a605c656f75858ec3bb76f2d48e7b491d90d93646" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"a").write "foo"
    (testpath/"b").write "foo"
    system bin/"diff", "a", "b"
  end
end
