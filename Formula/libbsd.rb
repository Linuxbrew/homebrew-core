class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.9.1.tar.xz"
  sha256 "56d835742327d69faccd16955a60b6dcf30684a8da518c4eca0ac713b9e0a7a4"
  # tag "linuxbrew"

  bottle do
    cellar :any_skip_relocation
    sha256 "0efc964be0372ef6082dce1b54a2ab515b7a2a62279a177c476d925da023c0d1" => :x86_64_linux # glibc 2.19
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
