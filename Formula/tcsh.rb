class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "http://www.tcsh.org/"
  url "ftp://ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  mirror "http://ftp.funet.fi/pub/mirrors/ftp.astron.com/pub/tcsh/tcsh-6.20.00.tar.gz"
  sha256 "b89de7064ab54dac454a266cfe5d8bf66940cb5ed048d0c30674ea62e7ecef9d"
  revision 1 if OS.linux?

  bottle do
    sha256 "3a59ccfdab60133b8854d528465882a3a8aaaa874f70ef1e4a0deee2f06802c6" => :sierra
    sha256 "d43bbcefe883ba5bd0dc998e5c4e6e9afcd35bacc780864fdcfe5a560002d7d1" => :el_capitan
    sha256 "ecbd811718e22c579434568185a8ea87d78d420c251913f84da8093f61d1b408" => :yosemite
    sha256 "54fecbc72f7186cd46f30e01bd0caa3afd766fe4c8de3f77ed440287d1c92d6a" => :x86_64_linux # glibc 2.19
  end

  depends_on "ncurses" unless OS.mac?

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
    bin.install_symlink "tcsh" => "csh" unless OS.mac?
  end

  test do
    (testpath/"test.csh").write <<-EOS.undent
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
