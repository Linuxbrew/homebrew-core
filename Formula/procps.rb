class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v3.3.16"
  sha256 "25eb11aefe6ecf3b4932e04d79b609bb0b9f735f31e15ddce86fcc9040ee48d1"
  head "https://gitlab.com/procps-ng/procps.git"
  # tag "linux"

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build
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
