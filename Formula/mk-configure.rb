# mk-configure: Build a bottle for Linux
class MkConfigure < Formula
  desc "Lightweight replacement for GNU autotools"
  homepage "https://github.com/cheusov/mk-configure"
  url "https://downloads.sourceforge.net/project/mk-configure/mk-configure/mk-configure-0.33.0/mk-configure-0.33.0.tar.gz"
  sha256 "93579c239a96a07b1ba3e7f6c0b298e9a7fbf19f0d850d66e5c9c36a37b7a2ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "faa0d51e2b96f31bf2562ef9a85f8306f666f9e246c8bfed69e2203b5d232545" => :catalina
    sha256 "faa0d51e2b96f31bf2562ef9a85f8306f666f9e246c8bfed69e2203b5d232545" => :mojave
    sha256 "faa0d51e2b96f31bf2562ef9a85f8306f666f9e246c8bfed69e2203b5d232545" => :high_sierra
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
