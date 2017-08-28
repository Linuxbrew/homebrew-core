class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v3.3.12"
  sha256 "b1036c109f271c7c50325b11a748236f8e58aa1dbafefb30c995ff1d05b4a1a8"
  head "https://gitlab.com/procps-ng/procps.git"
  # tag "linuxbrew"

  bottle do
    sha256 "28754c074aebd72e441dc845370e20c9305321653654c412b89e5086ddc63120" => :x86_64_linux # glibc 2.19
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "ncurses"

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system "#{bin}/ps", "--version"
    system "#{bin}/ps"
  end
end
