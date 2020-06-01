class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.15.tar.gz"
  sha256 "4a593dc5cceb2492a9669f5f5d69d0e517de457a11036788ea4591f33c5297fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "df4662de39f18d84000aaea85626da50d6076281e8823b093cff48111aadf2ec" => :catalina
    sha256 "f84f3f172a6949aff0a2a70f06a5b6e8fd05bd0a2ae18e1d6da7baf22378f0c6" => :mojave
    sha256 "f5aced7c926a8523011d5e4f503721fcf2b67287fa4df0af4357b72211581f43" => :high_sierra
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Older linuxes does not have this constant in /usr/include/linux/magic.h
    inreplace "src/dir_scan.c", "CGROUP2_SUPER_MAGIC", "0x63677270" unless OS.mac?
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
