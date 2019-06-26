class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v4/nano-4.3.tar.gz"
  sha256 "63b6dd621e3e21bb130ca931d761f84b48d974a7b5b4d489189c2df354ca2b4a"

  bottle do
    sha256 "7c9dd05e91de4291d7b5781e028f3d3389fee61f73d63d0a4a9c0fd6aa8a0e09" => :mojave
    sha256 "66dcf75d2f320c4990d769a82588c579dd5e979c4397a203c3bbf3f25e18d823" => :high_sierra
    sha256 "333b2cd8fb4c88833dc59061838c4fbd671d0e519d04d21a886b85ab144c4a79" => :sierra
    sha256 "85dd9f573df6e7e0c3fd940ee6057736a9ac36ae7bfb12ee462c5212a7ee5956" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"
  uses_from_macos "libmagic"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
