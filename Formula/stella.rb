class Stella < Formula
  desc "Atari 2600 VCS emulator"
  homepage "https://stella-emu.github.io/"
  url "https://github.com/stella-emu/stella/releases/download/6.5.2/stella-6.5.2-src.tar.xz"
  sha256 "dc2709d1501d33d9ec82cfeeedd6097993f3e2b117dde62092f2e604ba30bf99"
  license "GPL-2.0-or-later"
  revision 1 unless OS.mac?
  head "https://github.com/stella-emu/stella.git"

  bottle do
    sha256 cellar: :any,                 big_sur:      "a470ccd8535c906aae5aa63c595fae6946d4145afcf75eb626216c7822a52484"
    sha256 cellar: :any,                 catalina:     "19242437c7f91e204b162f8eb542fd76ab6cd4facb62904ecd4f5187ff88da8f"
    sha256 cellar: :any,                 mojave:       "b566cac3954c8b1c773845d3c55a23fc4f720ad41c16d51f4ec18eeddb58965a"
  end

  depends_on xcode: :build
  depends_on "libpng"
  depends_on "sdl2"

  unless OS.mac?
    fails_with gcc: "5"
    depends_on "gcc"
  end

  uses_from_macos "zlib"

  def install
    sdl2 = Formula["sdl2"]
    libpng = Formula["libpng"]
    cd "src/macos" do
      inreplace "stella.xcodeproj/project.pbxproj" do |s|
        s.gsub! %r{(\w{24} /\* SDL2\.framework)}, '//\1'
        s.gsub! %r{(\w{24} /\* png)}, '//\1'
        s.gsub!(/(HEADER_SEARCH_PATHS) = \(/,
                "\\1 = (#{sdl2.opt_include}/SDL2, #{libpng.opt_include},")
        s.gsub!(/(LIBRARY_SEARCH_PATHS) = ("\$\(LIBRARY_SEARCH_PATHS\)");/,
                "\\1 = (#{sdl2.opt_lib}, #{libpng.opt_lib}, \\2);")
        s.gsub!(/(OTHER_LDFLAGS) = "((-\w+)*)"/, '\1 = "-lSDL2 -lpng \2"')
      end
    end
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--with-sdl-prefix=#{sdl2.prefix}",
                          "--with-libpng-prefix=#{libpng.prefix}",
                          "--with-zlib-prefix=#{Formula["zlib"].prefix}"
    system "make", "install"
  end

  test do
    # Test is disabled for Linux, as it is failing with:
    # ERROR: Couldn't load settings file
    # ERROR: Couldn't initialize SDL: No available video device
    # ERROR: Couldn't create OSystem
    # ERROR: Couldn't save settings file
    assert_match "Stella version #{version}", shell_output("#{bin}/Stella -help").strip if OS.mac?
  end
end
