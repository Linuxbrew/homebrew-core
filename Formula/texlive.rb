class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  version "20181031"
  sha256 "3b09fa0ec09c33b43bb12113678275a2a816067f17282eeebec5df7f7aed343c"
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
    ENV["TEXLIVE_INSTALL_PREFIX"] = prefix
    system "./install-tl", "-scheme", scheme, "-portable", "-profile", "/dev/null"

    man1.install Dir[prefix/"texmf-dist/doc/man/man1/*"]
    man5.install Dir[prefix/"texmf-dist/doc/man/man5/*"]

    binarch = bin/"x86_64-linux"
    rm binarch/"man"
    Dir[binarch/"*"].each do |f|
      next unless File.symlink?(f)
      bin.install_symlink File.realpath(f) => File.basename(f)
    end
    Dir[binarch/"*"].each { |f| rm f if File.symlink?(f) }
    bin.install Dir[binarch/"*"]
    rmdir binarch
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tex --help")
  end
end
