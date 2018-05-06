# fig2dev: Build a bottle for Linuxbrew
class Fig2dev < Formula
  desc "Translates figures generated by xfig to other formats"
  homepage "https://mcj.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mcj/fig2dev-3.2.7a.tar.xz"
  sha256 "bda219a15efcdb829e6cc913a4174f5a4ded084bf91565c783733b34a89bfb28"

  bottle do
    sha256 "43ab38df1a59b1354326b9df617a370d865ee01e0b9924bebc7d50eaedd78504" => :high_sierra
    sha256 "5ce54788ded402638956c57526db334c25fc4a3fbd0dca29625c97a98a065499" => :sierra
    sha256 "e73cec0aff10bbcf4b6b940e33f7f5cfdc65a83faabd81a12b29655d70d23d17" => :el_capitan
  end

  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on :x11 => :optional
  depends_on "linuxbrew/xorg/xorg" if build.with?("x11") && !OS.mac?

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-transfig
    ]

    if build.with? "x11"
      args << "--with-xpm" << "--with-x"
    else
      args << "--without-xpm" << "--without-x"
    end

    system "./configure", *args
    system "make", "install"

    # Install a fig file for testing
    pkgshare.install "fig2dev/tests/data/patterns.fig"
  end

  test do
    system "#{bin}/fig2dev", "-L", "png", "#{pkgshare}/patterns.fig", "patterns.png"
    assert_predicate testpath/"patterns.png", :exist?, "Failed to create PNG"
  end
end
