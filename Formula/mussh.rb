class Mussh < Formula
  desc "Multi-host SSH wrapper"
  homepage "https://mussh.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/mussh/mussh/1.0/mussh-1.0.tgz"
  sha256 "6ba883cfaacc3f54c2643e8790556ff7b17da73c9e0d4e18346a51791fedd267"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9454e3f271552a7261a4009e43e77383fb87a62a418443437b74a568ff51cfb3"
  end

  def install
    bin.install "mussh"
    man1.install "mussh.1"
  end

  test do
    system "#{bin}/mussh", "--help"
  end
end
