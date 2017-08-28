class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.122/+download/byobu_5.122.orig.tar.gz"
  sha256 "0e5f14db8340712cf5b1049002c5b7f2a116ca28e6df418cb7500d3c4fa43234"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a557d087004fad0d9aece2161f7c3137e0e21e4ac8f2791efd1b644e66dd008" => :sierra
    sha256 "2a557d087004fad0d9aece2161f7c3137e0e21e4ac8f2791efd1b644e66dd008" => :el_capitan
    sha256 "2a557d087004fad0d9aece2161f7c3137e0e21e4ac8f2791efd1b644e66dd008" => :yosemite
    sha256 "2e97418b24ecc0dccd8dbc930af380a6acaa0b7332ddb5ec2f4e2d09faccb240" => :x86_64_linux # glibc 2.19
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt"

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
    EOS
  end

  test do
    system bin/"byobu-status"
  end
end
