class Help2man < Formula
  desc "Automatically generate simple man pages"
  homepage "https://www.gnu.org/software/help2man/"
  url "https://ftp.gnu.org/gnu/help2man/help2man-1.47.15.tar.xz"
  mirror "https://ftpmirror.gnu.org/help2man/help2man-1.47.15.tar.xz"
  sha256 "c25a35b30eceb315361484b0ff1f81c924e8ee5c8881576f1ee762f001dbcd1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :catalina
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :mojave
    sha256 "cba0670fe0e53aea5168c16650daf10871a3c0590341097d5a7ca18bedb4bcb8" => :high_sierra
    sha256 "93f5c1d8f0d05ee6be19259f0af279bf7151eb4a50078030af0952c75c57af61" => :x86_64_linux
  end

  def install
    # install is not parallel safe
    # see https://github.com/Homebrew/homebrew/issues/12609
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "help2man #{version}", shell_output("#{bin}/help2man #{bin}/help2man")
  end
end
