class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  version "20170414"
  sha256 "6aea7f8336d11cbdb3e90f4342e3611c5160fe9b22c77698a52c9f74b070f607"
  # tag "linuxbrew"

  bottle do
    sha256 "f529174ec1714d92a515604133c6bcd9b75224d995f013e84203a0a0e73a47b6" => :x86_64_linux # glibc 2.19
  end

  option "with-full", "install everything"
  option "with-medium", "install small + more packages and languages"
  option "with-small", "install basic + xetex, metapost, a few languages [default]"
  option "with-basic", "install plain and latex"
  option "with-minimal", "install plain only"

  depends_on :perl => ["5.14", :build] unless OS.mac?
  depends_on "fontconfig"

  def install
    scheme = %w[full medium small basic minimal].find do |x|
      build.with? x
    end || "small"

    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = prefix
    system "./install-tl", "-scheme", scheme, "-portable", "-profile", "/dev/null"

    binarch = bin/"x86_64-linux"
    man1.install Dir[binarch/"man/man1/*"]
    man5.install Dir[binarch/"man/man5/*"]
    bin.install_symlink Dir[binarch/"*"]
  end

  test do
    system "#{bin}/tex", "--version"
  end
end
