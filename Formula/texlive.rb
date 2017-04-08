class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "http://www.tug.org/texlive/"
  url "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
  version "20170408"
  sha256 "645897c1001c75d85da147dc2dc6f7dc6d9ddd404f3dfc83050242232c658c1a"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bcf9c7c88565af5349a880cf60724418e2c8e9d8439e2e0aa12c896e80406bf" => :x86_64_linux
  end

  option "with-full", "install everything"
  option "with-medium", "install small + more packages and languages"
  option "with-small", "install basic + xetex, metapost, a few languages [default]"
  option "with-basic", "install plain and latex"
  option "with-minimal", "install plain only"

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
