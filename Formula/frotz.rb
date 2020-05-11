class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.51/frotz-2.51.tar.gz"
  sha256 "7916f17061e845e4fa5047c841306c4be2614e9c941753f9739c5d39c7e9f05b"
  revision 1
  head "https://gitlab.com/DavidGriffith/frotz.git"

  bottle do
    sha256 "6917ea0ce2ce6b61e0bcf7a884a1617d74bebab7cb74a42b9013670f796a4fcc" => :catalina
    sha256 "8fb26f4a7b0e8d59f5002be8a83368dbb0ba04fd1818f9b0cb815b847c787558" => :mojave
    sha256 "d9abdc10abe135741446f19e2289606c69015f1142120dfb9be6863fe354b343" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libao"
  depends_on "libmodplug"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc}]
    system "make", "all", *args
    ENV.deparallelize # install has race condition
    system "make", "install_all", *args
  end

  test do
    assert_match "FROTZ", shell_output("#{bin}/frotz --version").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz --version").strip
    assert_match "FROTZ", shell_output("#{bin}/dfrotz --version").strip
  end
end
