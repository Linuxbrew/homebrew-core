class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.33.1/mk-configure-0.33.1.tar.gz"
  sha256 "481bcdd9498097ea2625b10f6a7d45c5a88a5baca9699b87cdcd177e4648b34b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :catalina
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :mojave
    sha256 "c357fa068eb6cdfde64567dc89dd644fb764febc203bdf0c43b804a039d3c86a" => :high_sierra
  end

  depends_on "bmake"
  depends_on "makedepend"

  def install
    ENV["PREFIX"] = prefix
    ENV["MANDIR"] = man

    system "bmake", "all"
    system "bmake", "install"
    doc.install "presentation/presentation.pdf"
  end

  test do
    system "#{bin}/mkcmake", "-V", "MAKE_VERSION", "-f", "/dev/null"
  end
end
