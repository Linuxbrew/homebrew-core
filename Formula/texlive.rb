class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  version "20190406"
  sha256 "c7742ea5b0bc22fe2742e9fa2bf9aeb8ff88175722fcfb2b72c00a29c06e2fc9"
  # tag "linuxbrew"

  bottle do
    cellar :any
  end

  option "with-full", "install everything"
  option "with-medium", "install small + more packages and languages"
  option "with-small", "install basic + xetex, metapost, a few languages [default]"
  option "with-basic", "install plain and latex"
  option "with-minimal", "install plain only"

  depends_on "wget" => :build
  depends_on "fontconfig"
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
    scheme = %w[full medium small basic minimal].find do |x|
      build.with? x
    end || "small"

    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = libexec
    system "./install-tl", "-scheme", scheme, "-portable", "-profile", "/dev/null"

    man1.install Dir[libexec/"texmf-dist/doc/man/man1/*"]
    man5.install Dir[libexec/"texmf-dist/doc/man/man5/*"]
    rm Dir[libexec/"bin/*/man"]
    bin.install_symlink Dir[libexec/"bin/*/*"]
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tex --help")
    assert_match "revision", shell_output("#{bin}/tlmgr --version")
  end
end
