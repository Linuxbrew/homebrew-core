class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  version "20200522"
  # sha256 "3438a18c53ecf3d13e212ad8f76f73e728a67134772857adf54f02aaefac033e"

  bottle do
    cellar :any_skip_relocation
  end

  depends_on "wget" => :build
  depends_on "fontconfig"
  depends_on :linux
  depends_on "linuxbrew/xorg/libice"
  depends_on "linuxbrew/xorg/libsm"
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/libxaw"
  depends_on "linuxbrew/xorg/libxext"
  depends_on "linuxbrew/xorg/libxmu"
  depends_on "linuxbrew/xorg/libxpm"
  depends_on "linuxbrew/xorg/libxt"
  depends_on "perl"

  def install
    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = libexec
    touch("zero.profile")
    system "./install-tl", "-scheme", "small", "-portable", "-profile", "zero.profile"

    man1.install Dir[libexec/"texmf-dist/doc/man/man1/*"]
    man5.install Dir[libexec/"texmf-dist/doc/man/man5/*"]
    rm Dir[libexec/"bin/*/man"]
    bin.install_symlink Dir[libexec/"bin/*/*"]
  end

  def caveats
    <<~EOS
      The small (~500 MB) distribution (scheme-small) is installed by default.
      You may install a larger (medium or full) scheme using one of:

          tlmgr install scheme-medium # 1.5 GB
          tlmgr install scheme-full # 6 GB

      For additional information use command:

          tlmgr info schemes
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tex --help")
    assert_match "revision", shell_output("#{bin}/tlmgr --version")
  end
end
