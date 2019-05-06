class Grep < Formula
  desc "GNU grep, egrep and fgrep"
  homepage "https://www.gnu.org/software/grep/"
  url "https://ftp.gnu.org/gnu/grep/grep-3.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/grep/grep-3.3.tar.xz"
  sha256 "b960541c499619efd6afe1fa795402e4733c8e11ebf9fafccc0bb4bccdc5b514"

  bottle do
    cellar :any
    rebuild 2
    sha256 "ca4b36489d4767f809516edaed8e4f869834dfca40e7ccfa2c697e1ffa771717" => :mojave
    sha256 "3d31c9e997b832a9035394e51191d4f26357b51412d78e0029e19d5a6fc7efdb" => :high_sierra
    sha256 "830c7d077c489b9276a314c631a32d539c476efa7fa3857e9ed5913aa92c9c06" => :sierra
    sha256 "d67a211df8eb3435df093891625ad0111cca5d2c8285ea37c25856e440591930" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "pcre"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-nls
      --prefix=#{prefix}
      --infodir=#{info}
      --mandir=#{man}
      --with-packager=Homebrew
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"

    %w[grep egrep fgrep].each do |prog|
      (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
      (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
    end

    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      All commands have been installed with the prefix "g".
      If you need to use these commands with their normal names, you
      can add a "gnubin" directory to your PATH from your bashrc like:
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  test do
    text_file = testpath/"file.txt"
    text_file.write "This line should be matched"

    if OS.mac?
      grepped = shell_output("#{bin}/ggrep match #{text_file}")
      assert_match "should be matched", grepped

      grepped = shell_output("#{opt_libexec}/gnubin/grep match #{text_file}")
      assert_match "should be matched", grepped
    end

    unless OS.mac?
      grepped = shell_output("#{bin}/grep match #{text_file}")
      assert_match "should be matched", grepped
    end
  end
end
