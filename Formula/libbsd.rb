class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.8.6.tar.xz"
  sha256 "467fbf9df1f49af11f7f686691057c8c0a7613ae5a870577bef9155de39f9687"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "0efc964be0372ef6082dce1b54a2ab515b7a2a62279a177c476d925da023c0d1" => :x86_64_linux
  end

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so"}")
  end
end
